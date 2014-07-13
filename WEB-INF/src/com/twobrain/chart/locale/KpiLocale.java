package com.twobrain.chart.locale;

import java.util.Collection;
import java.util.HashMap;
import java.util.Locale;
import java.util.ResourceBundle;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;

/**
 * 어플리케이션에서 로케일과 관련된 처리를 총괄하는 클래스.
 */
public class KpiLocale {

	private static HashMap bundleCache;

	private static LocaleConfig localeConfig;

	static {
		init();
	}

	private KpiLocale() {
	};

	/**
	 * 클래스 패스로부터 <code>/properties/locale.xml</code> 파일을 읽어들여서 SnaLocale 클래스를
	 * 초기화한다.
	 */
	public static void init() {
		init("/com/nexgens/chart/properties/locale.xml");
	}

	/**
	 * 지정된 설정 파일을 클래스 패스에서 읽어들여서 SnaLocale 클래스를 초기화한다.
	 * 
	 * @param configFile
	 *            환경 설정 파일
	 */
	public static void init(String configFile) {
		bundleCache = new HashMap();
		localeConfig = new LocaleConfig(configFile);
	}

	/**
	 * <pre>
	 *  리소스 번들을 구한다.
	 *  로케일 설정 파일(/com/nexgens/chart/properties/locale.xml)로부터 locale과 resource 정보를 읽어들인다.
	 * </pre>
	 * 
	 * @param localeCode
	 *            &lt;locale&gt; 태그의 code
	 * @param resourceCode
	 *            로케일 설정 파일의 &lt;resource-bundle&gt; 태그의 code
	 * @return 메시지 포맷팅이 가능한 리소스 번들. 문자열 중간의 {0}, {1}등을 처리
	 */
	public static MessageBundle getMessageBundle(String localeCode, String resourceCode) {
		LocaleConfigVO vo = localeConfig.getLocaleConfig(localeCode);

		// 시스템에서 지원하지 않는 localeCode 일 경우,
		// 기본 로케일 코드 적용
		if (vo == null) {
			vo = localeConfig.getLocaleConfig(localeConfig.getDefaultCode());
		}

		Locale locale = new Locale(vo.getLanguage(), vo.getCountry());
		return getMessageBundle(locale, resourceCode);
	}

	/**
	 * <pre>
	 *  리소스 번들을 구한다.
	 *  사용자의 세션에 Locale을 저장하여 이후에 재사용한다.
	 * </pre>
	 * 
	 * @param request
	 *            이 request를 기초로 사용자의 Locale을 찾음. getLocale() 참조.
	 * @param resourceCode
	 *            로케일 설정 파일의 &lt;resource-bundle&gt; 태그의 code
	 * @return 사용자의 언어와 지역에 맞는 리소스 번들
	 */
	public static MessageBundle getMessageBundle(HttpServletRequest request, String resourceCode) {
		Locale locale = getLocale(request);
		return getMessageBundle(locale, resourceCode);
	}

	/**
	 * <pre>
	 *  리소스 번들을 구한다.
	 * </pre>
	 * 
	 * @param locale
	 *            리소스 번들의 locale
	 * @param resourceCode
	 *            로케일 설정 파일의 &lt;resource-bundle&gt; 태그의 code
	 * @return 사용자의 언어와 지역에 맞는 리소스 번들
	 */
	public static MessageBundle getMessageBundle(Locale locale, String resourceCode) {
		MessageBundle bundle = null;
		try {
			String resourceName = localeConfig.getResourceName(resourceCode);
			String key = resourceName + "_" + locale;

			bundle = (MessageBundle) bundleCache.get(key);
			if (bundle != null) {
				return bundle;
			}

			// System.out.println("new resource-bundle : " + key);
			bundle = new MessageBundle();
			ResourceBundle resBundle =
			// ResourceBundle.getBundle(resourceName, locale);
			ReloadablePropertyResourceBundle.getResourceBundle(resourceName, locale);
			bundle.setBundle(resBundle);

			bundleCache.put(key, bundle);
		} catch (Exception e) {
			e.printStackTrace();
		}

		return bundle;
	}

	/**
	 * <pre>
	 *  사용자의 Locale를 구한다.
	 *  Locale을 구하는 순서는 다음과 같다.
	 *    1. 사용자의 session에 &quot;LOCALE&quot;이라는 이름으로 Locale이 존재하는지 검사한다.
	 *    2. 사용자의 session에 &quot;LOCALE&quot;이 없으면 &quot;LANG&quot; 값이 존재하는지 검사한다.
	 *        존재한다면 로케일 설정 파일로부터 &quot;LANG&quot; 값을 코드로 가지고 있는
	 *        Locale 정보를 읽어들인다.
	 *        생성된 Locale을 session에 저장한다.
	 *    3. session에 &quot;LOCALE&quot;과 &quot;LANG&quot; 값이 존재하지 않으면, locale.xml에 선언된 기본 Locale을 사용한다.
	 * </pre>
	 * 
	 * @param request
	 *            사용자의 요청 정보.
	 * @return Locale
	 */
	public static Locale getLocale(HttpServletRequest request) {
		HttpSession session = request.getSession();
		Locale locale = (Locale) session.getAttribute("LOCALE");
		if (locale != null) {
			return locale;
		}

		String localeCode = (String) session.getAttribute("SELECTED_LANG");

		// SELECTED_LANG 값이 없을 경우 기본 Locale 코드값을 사용
		if (localeCode == null) {
			localeCode = localeConfig.getDefaultCode();
		}

		if (localeCode != null) {
			LocaleConfigVO vo = localeConfig.getLocaleConfig(localeCode);

			// SELECTED_LANG 값이 locale.xml에 없을 경우 기본 Locale 코드값을 사용
			if (vo == null) {
				localeCode = localeConfig.getDefaultCode();
				vo = localeConfig.getLocaleConfig(localeCode);
			}

			locale = new Locale(vo.getLanguage(), vo.getCountry());
			session.setAttribute("LOCALE", locale);
			return locale;
		}

		return request.getLocale();
	}

	/**
	 * <pre>
	 *  전체 Locale정보를 구한다.
	 * </pre>
	 * 
	 * @param
	 * @return HashMap
	 */
	public static HashMap getLocaleHashMap() {
		return localeConfig.getLocaleConfig();
	}

	/**
	 * <pre>
	 *  전체 Locale정보를 배열로 구한다.
	 * </pre>
	 * 
	 * @param
	 * @return HashMap
	 */
	public static LocaleConfigVO[] getLocaleConfigArray() {
		HashMap configMap = localeConfig.getLocaleConfig();

		LocaleConfigVO[] configArray = new LocaleConfigVO[configMap.size()];
		Collection values = configMap.values();
		values.toArray(configArray);

		return configArray;
	}

	/**
	 * <pre>
	 *  전체 Locale정보를 배열로 구한다.
	 * </pre>
	 * 
	 * @param
	 * @return HashMap
	 */
	public static LocaleConfigVO getLocaleConfig(String localeCode) {
		LocaleConfigVO vo = localeConfig.getLocaleConfig(localeCode);

		return vo;
	}

	public static String getDefaultCode() {
		return localeConfig.getDefaultCode();
	}
}
