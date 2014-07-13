package com.twobrain.chart.locale;

import java.text.MessageFormat;
import java.util.Locale;
import java.util.ResourceBundle;

/**
 * java.util.ResourceBundle 과 java.text.MessageFormat 을 결합한 클래스
 */
public class MessageBundle {

	private ResourceBundle bundle;

	public ResourceBundle getBundle() {
		return bundle;
	}

	public void setBundle(ResourceBundle value) {
		bundle = value;
	}

	/**
	 * 리소스 번들에서 문자열을 읽는다.
	 * 
	 * @param key
	 *            리소스 번들의 key
	 * @return 리소스 번들의 key값에 대응하는 문자열. key값이 발견되지 않으면
	 *         &lt;&lt;key&gt;&gt;__not_found 문자열을 리턴한다.
	 */
	public String getString(String key) {
		String value = key + "__not_found";
		try {
			value = bundle.getString(key);
		} catch (Exception e) {
			System.out.println(value);
		}

		return value;
	}

	/**
	 * 리소스 번들에서 문자열 배열을 읽는다.
	 * 
	 * @param key
	 *            리소스 번들의 key
	 * @return 리소스 번들의 key값에 대응하는 문자열 배열. key값이 발견되지 않으면 Exception이 발생한다.
	 */
	public String[] getStringArray(String key) {
		return bundle.getStringArray(key);
	}

	/**
	 * 리소스 번들에 설정된 로케일을 읽는다.
	 */
	public Locale getLocale() {
		return bundle.getLocale();
	}

	/**
	 * 리소스 번들에서 문자열을 읽는다.
	 * 
	 * @param key
	 *            리소스 번들의 key
	 * @param params
	 *            결과 문자열에 있는 {0}, {1}, {2}... 문자열에 대체될 Object배열
	 * @return 리소스 번들의 key값에 대응하는 문자열. key값이 발견되지 않으면
	 *         &lt;&lt;key&gt;&gt;__not_found 문자열을 리턴한다.
	 */
	public String getString(String key, Object[] params) {
		return MessageFormat.format(getString(key), params);
	}

	/**
	 * 리소스 번들에서 문자열을 읽는다.
	 * 
	 * @param key
	 *            리소스 번들의 key
	 * @param param0
	 *            결과 문자열에 있는 {0} 문자열에 대체될 Object
	 * @return 리소스 번들의 key값에 대응하는 문자열. key값이 발견되지 않으면
	 *         &lt;&lt;key&gt;&gt;__not_found 문자열을 리턴한다.
	 */
	public String getString(String key, Object param0) {
		Object[] parmas = { param0 };
		return getString(key, parmas);
	}

	/**
	 * 리소스 번들에서 문자열을 읽는다.
	 * 
	 * @param key
	 *            리소스 번들의 key
	 * @param param0
	 *            결과 문자열에 있는 {0} 문자열에 대체될 Object
	 * @param param1
	 *            결과 문자열에 있는 {1} 문자열에 대체될 Object
	 * @return 리소스 번들의 key값에 대응하는 문자열. key값이 발견되지 않으면
	 *         &lt;&lt;key&gt;&gt;__not_found 문자열을 리턴한다.
	 */
	public String getString(String key, Object param0, Object param1) {
		Object[] parmas = { param0, param1 };
		return getString(key, parmas);
	}

	/**
	 * 리소스 번들에서 문자열을 읽는다.
	 * 
	 * @param key
	 *            리소스 번들의 key
	 * @param param0
	 *            결과 문자열에 있는 {0} 문자열에 대체될 Object
	 * @param param1
	 *            결과 문자열에 있는 {1} 문자열에 대체될 Object
	 * @param param2
	 *            결과 문자열에 있는 {2} 문자열에 대체될 Object
	 * @return 리소스 번들의 key값에 대응하는 문자열. key값이 발견되지 않으면
	 *         &lt;&lt;key&gt;&gt;__not_found 문자열을 리턴한다.
	 */
	public String getString(String key, Object param0, Object param1, Object param2) {
		Object[] parmas = { param0, param1, param2 };
		return getString(key, parmas);
	}

	/**
	 * 리소스 번들에서 문자열을 읽는다.
	 * 
	 * @param key
	 *            리소스 번들의 key
	 * @param param0
	 *            결과 문자열에 있는 {0} 문자열에 대체될 Object
	 * @param param1
	 *            결과 문자열에 있는 {1} 문자열에 대체될 Object
	 * @param param2
	 *            결과 문자열에 있는 {2} 문자열에 대체될 Object
	 * @param param3
	 *            결과 문자열에 있는 {3} 문자열에 대체될 Object
	 * @return 리소스 번들의 key값에 대응하는 문자열. key값이 발견되지 않으면
	 *         &lt;&lt;key&gt;&gt;__not_found 문자열을 리턴한다.
	 */
	public String getString(String key, Object param0, Object param1, Object param2, Object param3) {
		Object[] parmas = { param0, param1, param2, param3 };
		return getString(key, parmas);
	}
}
