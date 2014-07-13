package com.twobrain.common.session;

import java.util.HashMap;
import java.util.Set;

import javax.servlet.http.HttpSession;


public class UserMonitor {

    static private UserMonitor instance; // The single instance

    private HashMap monitor = null;

    /**
     * Returns the single instance, creating one if it's the first time this method is called.
     * 
     * @return LgnUserMonitor The single instance.
     */
    static synchronized public UserMonitor getInstance() {
        if(instance == null) {
            instance = new UserMonitor();
        }
        return instance;
    }

    /**
     * A private constructor since this is a Singleton
     */
    private UserMonitor() {
        init();
    }

    /**
     * 해쉬맵하나를 static 변수에 저장한다.
     */
    private void init() {
        monitor = new HashMap();
    }

    /**
     * 유저세션의 세션객체를 monitor에서 갖고온다.
     * 
     * @param key 사용자객체
     * @return HttpSession 객체를 리턴한다.
     */
    public HttpSession getUserSession(Object key) {
        return (HttpSession)monitor.get(key);
    }

    /**
     * 유저세션의 세션객체를 monitor에 넣는다.
     * 
     * @param key 사용자객체
     * @param value 사용자객체가 저장된 세션객체
     * @return previous value associated with specified key, or null if there was no mapping for key. A null
     *         return can also indicate that the HashMap previously associated null with the specified key.
     */
    public Object putUserSession(Object key, Object value) {
        return monitor.put(key, value);
    }

    /**
     * monitor에서 유저세션의 세션객체를 제거한다.
     * 
     * @return previous value associated with specified key, or null if there was no mapping for key. A null
     *         return can also indicate that the map previously associated null with the specified key.
     */
    public Object removeUserSession(Object key) {
        return monitor.remove(key);
    }

    /**
     * monitor에서 유저세션 키의 값이 있는지 검사.
     * 
     * @return true if this map contains a mapping for the specified key.
     */
    public boolean containsKey(Object key) {
        return monitor.containsKey(key);
    }

    /**
     * monitor에서 유저세션이 있는지 검사.
     * 
     * @return true if this map maps one or more keys to the specified value.
     */
    public boolean containsValue(Object value) {
        return monitor.containsValue(value);
    }

    /**
     * monitor에서 유저세션의 갯수.
     * 
     * @return true if this map maps one or more keys to the specified value.
     */
    public int size() {
        return monitor.size();
    }

    /**
     * Returns a set view of the keys contained in this map. The set is backed by the map, so changes to the
     * map are reflected in the set, and vice-versa. The set supports element removal, which removes the
     * corresponding mapping from this map, via the Iterator.remove, Set.remove, removeAll, retainAll, and
     * clear operations. It does not support the add or addAll operations.
     * 
     * @return a set view of the keys contained in this map.
     */
    public Set keySet() {
        return monitor.keySet();
    }
}