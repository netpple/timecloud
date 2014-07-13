package com.twobrain.common.object;

import lombok.Getter;
import lombok.Setter;

/**
 * Created by Cristina on 2014-07-11.
 */
public class JsonUserImage {
    @Setter @Getter public int idx = 0;
    @Setter @Getter public int ownerIdx = 0;
    @Setter @Getter public String ownerName = "";
    @Setter @Getter public String name = "";
    @Setter @Getter public String size = "";
    @Setter @Getter public String url = "";
    @Setter @Getter public String thumbnailUrl = "";
    @Setter @Getter public String deleteUrl = "";
    @Setter @Getter public String deleteType = "";
    @Setter @Getter public String date = "";
    @Setter @Getter public int thumbnailWidth = 0;
    @Setter @Getter public int thumbnailHeight = 0;
    @Setter @Getter public String selectedYn = "N";
}
