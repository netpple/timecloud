package com.twobrain.chart.locale;

import java.io.InputStream;
import java.util.HashMap;

import javax.xml.parsers.DocumentBuilder;
import javax.xml.parsers.DocumentBuilderFactory;

import org.w3c.dom.Document;
import org.w3c.dom.Element;
import org.w3c.dom.NamedNodeMap;
import org.w3c.dom.Node;
import org.w3c.dom.NodeList;

class LocaleConfig {
	private HashMap localePool;
	private HashMap resourceNamePool;
	private String defaultLocaleCode;

	public LocaleConfig(String xmlPath) {
		localePool = new HashMap();
		resourceNamePool = new HashMap();
		loadLocaleFromXml(xmlPath);
	}

	public LocaleConfigVO getLocaleConfig(String localeCode) {
		return (LocaleConfigVO) localePool.get(localeCode);
	}

	public String getDefaultCode() {
		return defaultLocaleCode;
	}

	public HashMap getLocaleConfig() {
		return localePool;
	}

	public String getResourceName(String code) {
		return (String) resourceNamePool.get(code);
	}

	private void loadLocaleFromXml(String xmlPath) {
		InputStream fis = null;
		try {
			DocumentBuilderFactory factory = DocumentBuilderFactory.newInstance();
			DocumentBuilder builder = factory.newDocumentBuilder();

			fis = (new LocaleConfigVO()).getClass().getResourceAsStream(xmlPath);
			// System.out.println(xmlPath + " : " + fis);

			Document document = builder.parse(fis);
			Element root = document.getDocumentElement();
			NodeList locales = root.getElementsByTagName("locale");
			int localeCount = locales.getLength();
			for (int i = 0; i < localeCount; i++) {
				Node node = locales.item(i);
				NamedNodeMap attrs = node.getAttributes();
				if (attrs != null) {
					LocaleConfigVO vo = new LocaleConfigVO();
					String localeCode = attrs.getNamedItem("code").getNodeValue();
					vo.setLanguage(attrs.getNamedItem("language").getNodeValue());
					vo.setCountry(attrs.getNamedItem("country").getNodeValue());
					vo.setEncoding(attrs.getNamedItem("encoding").getNodeValue());
					vo.setFileEncoding(attrs.getNamedItem("file-encoding").getNodeValue());
					vo.setDisplayName(attrs.getNamedItem("display-name").getNodeValue());
					vo.setDefaultYn(attrs.getNamedItem("default").getNodeValue());
					localePool.put(localeCode, vo);

					if (vo.getDefaultYn().equals("Y")) {
						defaultLocaleCode = localeCode;
					}
				}
			}

			NodeList bundles = root.getElementsByTagName("resource-bundle");
			int bundleCount = bundles.getLength();
			for (int i = 0; i < bundleCount; i++) {
				Node node = bundles.item(i);
				NamedNodeMap attrs = node.getAttributes();
				if (attrs != null) {
					String code = attrs.getNamedItem("code").getNodeValue();
					String resource = attrs.getNamedItem("resource").getNodeValue();
					resourceNamePool.put(code, resource);
				}
			}

		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			try {
				fis.close();
			} catch (Exception ignore) {
			}
		}
	}
}