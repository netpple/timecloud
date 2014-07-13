package com.twobrain.chart.locale;

import java.io.File;
import java.io.IOException;
import java.io.InputStream;
import java.net.URL;
import java.net.URLConnection;
import java.util.Locale;
import java.util.MissingResourceException;
import java.util.PropertyResourceBundle;
import java.util.ResourceBundle;
import java.util.Vector;

public class ReloadablePropertyResourceBundle extends PropertyResourceBundle {
	private static final String FILE_SUFIX = ".properties";

	private static sun.misc.SoftCache cacheList = new sun.misc.SoftCache();

	private static final AGResourceCacheKey cacheKey = new AGResourceCacheKey();

	private static final Object NOLOADER_NOTFOUND = new Integer(-1);

	private long lastModified = 0;

	private java.lang.String fileName = "";

	public ReloadablePropertyResourceBundle(java.io.InputStream stream) throws java.io.IOException {
		super(stream);
	}

	public ReloadablePropertyResourceBundle(java.io.InputStream stream, String fileName, long lastModified)
			throws java.io.IOException {
		super(stream);
		this.fileName = fileName;
		this.lastModified = lastModified;
	}

	private static ClassLoader getLoader() {
		Class[] stack = new SecurityManager() {
			public Class[] getClassContext() {
				return super.getClassContext();
			}
		}.getClassContext();

		/* Magic number 2 identifies our caller's caller */
		Class c = stack[2];
		ClassLoader cl = (c == null) ? null : c.getClassLoader();
		if (cl == null) {
			cl = ClassLoader.getSystemClassLoader();
		}
		return cl;
	}

	public static ResourceBundle getResourceBundle(String baseName) throws MissingResourceException {
		return getResourceBundle(baseName, Locale.getDefault());
	}

	public static ResourceBundle getResourceBundle(String baseName, Locale locale) throws MissingResourceException {
		return getResourceBundle(baseName, locale, getLoader());
	}

	public static ResourceBundle getResourceBundle(String baseName, Locale locale, ClassLoader loader)
			throws MissingResourceException {
		StringBuffer localeName = new StringBuffer("_").append(locale.toString());
		if (locale.toString().equals(""))
			localeName.setLength(0);

		ResourceBundle lookup = searchBundle(baseName, localeName, loader, false);
		if (lookup == null) {
			localeName.setLength(0);
			localeName.append("_").append(Locale.getDefault().toString());
			lookup = searchBundle(baseName, localeName, loader, true);
			if (lookup == null) {
				throw new MissingResourceException("Can't find resource for base name " + baseName + ", locale "
						+ locale, baseName + "_" + locale, "");
			}
		}
		// No parents
		return lookup;
	}

	private static URL getUrl(final String name, final ClassLoader loader) {
		URL url = (URL) java.security.AccessController.doPrivileged(new java.security.PrivilegedAction() {
			public Object run() {
				if (loader != null) {
					return loader.getResource(name);
				} else {
					return ClassLoader.getSystemResource(name);
				}
			}
		});
		return url;
	}

	private static ResourceBundle searchBundle(String baseName, StringBuffer localeName, final ClassLoader loader,
			boolean includeBase) {
		String localeStr = localeName.toString();
		String baseFileName = baseName.replace('.', '/');
		Object lookup = null;
		String searchName;
		Vector cacheCandidates = new Vector();
		int lastUnderbar;
		InputStream stream = null;
		URL url = null;
		long lastDate = 0;
		URLConnection urlCon = null;

		Object NOTFOUND;
		if (loader == null) {
			NOTFOUND = NOLOADER_NOTFOUND;
		} else {
			NOTFOUND = loader;
		}

		searchLoop: while (true) {
			// look the property file
			searchName = baseFileName + localeStr + FILE_SUFIX;
			final String resName = searchName;

			// look in the cache
			synchronized (cacheList) {
				cacheKey.setKeyValues(loader, searchName);
				lookup = cacheList.get(cacheKey);

				// If the value == the class loader, this
				// signifies that a prior search failed
				if (lookup == NOTFOUND) {
					localeName.setLength(0);
					break searchLoop;
				}
				if (lookup != null) {
					// Creation date
					if (lookup instanceof ReloadablePropertyResourceBundle) {
						String fileName = ((ReloadablePropertyResourceBundle) lookup).fileName;
						url = getUrl(fileName, loader);
						if (url != null) {
							lastDate = new File(url.getFile()).lastModified();
						}
						if ((url != null && ((ReloadablePropertyResourceBundle) lookup).lastModified == lastDate)
								|| lastDate == 0) {
							localeName.setLength(0);
							break searchLoop;
						} else {
							url = null;
							lookup = null;
							cacheList.remove(cacheKey);
						}
					} else {
						localeName.setLength(0);
						break searchLoop;
					}
				}
				cacheCandidates.addElement(cacheKey.clone());
				cacheKey.setKeyValues(null, "");
			}

			if (url == null) {
				url = getUrl(resName, loader);
			}
			if (url != null) {
				try {
					urlCon = url.openConnection();
				} catch (Exception e) {
				}
			}
			if (urlCon != null) {
				try {
					stream = urlCon.getInputStream();
					lastDate = new File(url.getFile()).lastModified();
				} catch (IOException e) {
				}
			}
			if (stream != null) {
				// make sure it is buffered
				stream = new java.io.BufferedInputStream(stream);
				try {
					lookup = (Object) new ReloadablePropertyResourceBundle(stream, resName, lastDate);
					break searchLoop;
				} catch (Exception e) {
				} finally {
					try {
						stream.close();
					} catch (Exception e) {
						// to avoid propagating an IOException back into the
						// caller
						// (I'm assuming this is never going to happen, and if
						// it does,
						// I'm obeying the precedent of swallowing exceptions
						// set by the
						// existing code above)
					}
				}
			}

			// Chop off the last part of the locale name string and try again.
			lastUnderbar = localeStr.lastIndexOf('_');
			if (((lastUnderbar == 0) && (!includeBase)) || (lastUnderbar == -1)) {
				break;
			}
			localeStr = localeStr.substring(0, lastUnderbar);
			localeName.setLength(lastUnderbar);
		}

		// If we searched all the way to the base, then we can add
		// the NOTFOUND result to the cache. Otherwise we can say
		// nothing.
		if (lookup == null && includeBase == true)
			lookup = NOTFOUND;

		if (lookup != null)
			synchronized (cacheList) {
				// Add a positive result to the cache. The result may include
				// NOTFOUND
				for (int i = 0; i < cacheCandidates.size(); i++) {
					cacheList.put(cacheCandidates.elementAt(i), lookup);
				}
			}

		if ((lookup == NOTFOUND) || (lookup == null))
			return null;
		else
			return (ResourceBundle) lookup;
	}
}
