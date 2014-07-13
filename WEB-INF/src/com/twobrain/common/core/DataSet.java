package com.twobrain.common.core;

import java.util.HashMap;

public class DataSet {

	public String[] result = null;
	public int numOfColumn;				//컬럼의수
	public int numOfRow;				//레코드의수
	public int currentRowCount = 0;		//현재레코드 카운트
	public HashMap columnName = new HashMap();
	  
	/*구한 값들을 맴버변수에 할당*/
	public DataSet(String[] data, int numOfColumn, HashMap columnName) {
	    this.result = data;								//모든 ResueltSet이 일차원배열에 담아진다
	    this.numOfColumn = numOfColumn;					//컬럼의 수를 세팅
	    this.numOfRow = data.length/numOfColumn;		//배열의 총크기를 컬럼수로 나누어서 레코드의 수를 알아낸다
	    this.columnName = columnName;
	}
	
	/**
	 * 조회된 데이터의 원본 배열을 리턴한다.
	 * @return
	 */
	public String[] getOriginData() {
		return result;
	}

	/*현재 레코드의 위치가 총레코드수를 오버했는지 채크*/
	public boolean next() {
		if (numOfRow > this.currentRowCount) {
			this.currentRowCount++;
			return true;
	    } else {
	    	return false;
	    }
	}

	/*현재 레코드의 위치를 특정위치로 이동 */
	public boolean absolute(int intValue) {
	    if (numOfRow >= intValue) {
	    	this.currentRowCount = intValue;
	    	return true;
	    } else {
	    	return false;
	    }
	}
	  
	/*현재 레코드의 위치를 첫번째 레코드로 이동 */
	public boolean first() {
	    if (numOfRow >= this.currentRowCount) {
	    	this.currentRowCount = 0;
	    	return true;
	    } else {
	    	return false;
	    }
	}  

    public int findColumn(String columnName) {
        Integer index = (Integer) this.columnName.get(columnName.toUpperCase());

        if (index == null) {
        }
        
        return index.intValue();
    }
    
	/*필드의 값을 스트링으로 가져온다*/
	public String getString(int index) {
	    if (index > numOfColumn || currentRowCount < 1 || numOfRow < currentRowCount)
	    	throw new java.lang.IndexOutOfBoundsException();

	    return result[(numOfColumn*(currentRowCount-1)+index)-1];
	}

	public String getString(String name) {
		return getString(findColumn(name));	
	}
	
	/*필드의 값을 숫자로가져온다*/
	public int getInt(int index) throws IndexOutOfBoundsException,NumberFormatException {
	    return Integer.parseInt(this.getString(index));
	}
	
	public int getInt(String name) {
		return getInt(findColumn(name));
	}
	
	/*필드의 값을 더블형으로로 가져온다*/
	public double getDouble(int index) throws IndexOutOfBoundsException,NumberFormatException {
	    return Double.parseDouble(this.getString(index));
	}
	
	public double getDouble(String name) {
		return getDouble(findColumn(name));
	}
	  
	/*필드의 값을 플로트형으로 가져온다*/
	public float getFloat(int index) throws IndexOutOfBoundsException,NumberFormatException {
	    return Float.parseFloat(this.getString(index));
	}  
	
	public float getFloat(String name) {
		return getFloat(findColumn(name));
	}

	public int getNumberOfColumn () {
	    return numOfColumn;
	}

	/*레코드셋의 결과를 이차원배열에 담아온다*/
	public String[][] getData() {
	    String[][] str = new String[numOfRow][numOfColumn];

	    for(int i = 0; i < numOfRow; i++) {
	    	for(int j = 0; j < numOfColumn; j++) {
	    		str[i][j] = result[numOfColumn*i+j];
	    	}
	    }

	    return str;
	}
	  
	/*현재 데이타셋의 전체 레코드수를 담아온다*/
	public int size() {   	 
	  	return this.numOfRow;
	}

}
