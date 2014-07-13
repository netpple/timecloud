package com.twobrain.chart.locale;

import java.lang.ref.SoftReference;

public class AGResourceCacheKey implements Cloneable {
	private SoftReference loaderRef;

	private String searchName;

	private int hashCodeCache;

	public boolean equals(Object other) {
		if (this == other) {
			return true;
		}
		if (null == other) {
			return false;
		}
		if (!(other instanceof AGResourceCacheKey)) {
			return false;
		}

		AGResourceCacheKey otherEntry = (AGResourceCacheKey) other;
		boolean result = hashCodeCache == otherEntry.hashCodeCache;
		if (result) {
			// are the names the same
			result = searchName.equals(otherEntry.searchName);
			if (result) {
				final boolean hasLoaderRef = loaderRef != null;
				// are refs (both non-null) or (both null)
				result = (hasLoaderRef && (otherEntry.loaderRef != null)) || (loaderRef == otherEntry.loaderRef);
				// if both non-null, check that they reference the same loader
				if (result && hasLoaderRef) {
					result = loaderRef.get() == otherEntry.loaderRef.get();
				}
			}
		}
		return result;
	}

	public int hashCode() {
		return hashCodeCache;
	}

	public Object clone() {
		try {
			return super.clone();
		} catch (CloneNotSupportedException e) {
			throw new InternalError();
		}
	}

	public void setKeyValues(ClassLoader loader, String searchName) {
		this.searchName = searchName;
		hashCodeCache = searchName.hashCode();
		if (loader == null) {
			this.loaderRef = null;
		} else {
			loaderRef = new SoftReference(loader);
			hashCodeCache ^= loader.hashCode();
		}
	}
}
