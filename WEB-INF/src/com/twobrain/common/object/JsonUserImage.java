package com.twobrain.common.object;

import lombok.Getter;
import lombok.Setter;

/**
 * Created by Cristina on 2014-07-11.
 */
public class JsonUserImage {
    @Setter @Getter public int idx = 0;
    @Setter @Getter public int ownerIdx = 0;
    @Setter @Getter public String name = "";
    @Setter @Getter public String size = "";
    @Setter @Getter public String url = "";
    @Setter @Getter public String deleteUrl = "";
}
