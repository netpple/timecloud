package com.twobrain.dao;

import com.twobrain.common.core.DataSet;
import com.twobrain.common.core.QueryHandler;
import lombok.Getter;

import java.util.ArrayList;
import java.util.List;

/**
 * Created by netpple on 2014. 7. 21..
 */
public class DomainInfo {
    @Getter
    final private String idx ;
    @Getter final private String name ;
    @Getter final private String regDatetime ;
    @Getter final private String edtDatetime ;
    @Getter final private String offYn ;
    @Getter final private String userCnt;
    @Getter final private String ownerIdx;
    @Getter final private String ownerName;

    public static List<DomainInfo> getDomains(){
        DataSet ds = QueryHandler.executeQuery("SELECT_DOMAIN_LIST") ;
        if(ds == null || ds.size()<1) return null;

        List<DomainInfo> domains = new ArrayList<DomainInfo>();
        while(ds.next()){
            domains.add(new DomainInfo(ds));
        }

        return domains;
    }
    public static DomainInfo getInstance(final String domain_idx){
        DataSet ds = QueryHandler.executeQuery("SELECT_DOMAIN_INFO", domain_idx);
        if (ds == null || !ds.next())return null;
        DomainInfo domain = new DomainInfo(ds);
        return domain ;
    }

    public DomainInfo (DataSet ds) {
        this.idx = ds.getString("N_IDX") ;
        this.name = ds.getString("V_NAME") ;
        this.offYn = ds.getString("C_OFF_YN") ;
        this.regDatetime = ds.getString("V_REG_DATETIME") ;
        this.edtDatetime = ds.getString("V_EDT_DATETIME") ;
        this.userCnt = ds.getString("USER_CNT");
        this.ownerIdx = ds.getString("N_OWNER_IDX");
        this.ownerName = ds.getString("OWNER_NAME");
    }

    public boolean isOFF(){
        return "Y".equals(getOffYn()) ;
    }
}
