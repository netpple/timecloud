package com.twobrain.common.util;

/**
 * Created by netpple on 2014. 7. 12..
 */
public class Html {
    private Html(){}
    // -- box - block
    public static String div(String txt) { return div(txt,"") ; }
    public static String div(String txt,String attrs) { return markup("div",txt,attrs) ;}
    public static String p(String txt) { return p(txt,"") ; }
    public static String p(String txt,String attrs) { return markup("p",txt,attrs) ;}

    // -- button
    public static String button(String txt) { return button(txt,"") ; }
    public static String button(String txt,String attrs) { return markup("button",txt,attrs) ;}

    // -- box - inline
    public static String span(String txt) { return span(txt,"") ; }
    public static String span(String txt,String attrs) { return markup("span",txt,attrs) ;}

    // --
    public static String img_(String attrs) {
        return markupInline("img", attrs) ;
    }

    // -- link
    public static String a(String txt) { return a(txt,"") ; }
    public static String a(String txt,String attrs) { return markup("a",txt,attrs) ;}
    // -- table
    public static String table(String txt) { return table(txt,"") ; }
    public static String table(String txt,String attrs) { return markup("table",txt,attrs) ;}
    public static String tr(String txt) { return tr(txt,"") ; }
    public static String tr(String txt,String attrs) { return markup("tr",txt,attrs) ;}
    public static String td(int txt) { return td(""+txt) ; }
    public static String td(int txt,String attrs) { return td(""+txt,attrs) ;}
    public static String td(String txt) { return td(txt,"") ; }
    public static String td(String txt,String attrs) { return markup("td",txt,attrs) ;}


    // -- list
    public static String ul(String txt) { return ul(txt,"") ; }
    public static String ul(String txt,String attrs) { return markup("ul",txt,attrs) ;}
    public static String li(String txt) { return li(txt,"") ; }
    public static String li(String txt,String attrs) { return markup("li",txt,attrs) ;}
    // -- font
    public static String small(String txt) { return small(txt,"") ; }
    public static String small(String txt,String attrs) { return markup("small",txt,attrs) ;}
    public static String strike(String txt) { return strike(txt,"") ; }
    public static String strike(String txt,String attrs) { return markup("strike",txt,attrs) ;}
    public static String em(String txt) { return em(txt,"") ; }	// italics
    public static String em(String txt,String attrs) { return markup("em",txt,attrs) ;}	// italics


    public static String strong(String txt) { return strong(txt,"") ; }
    public static String strong(String txt,String attrs) { return markup("strong",txt,attrs) ;}
    public static String b(String txt) { return b(txt,"") ; }
    public static String b(String txt,String attrs) { return markup("b",txt,attrs) ;}
    public static String i(String txt) { return i(txt,"") ; }
    public static String i(String txt,String attrs) { return markup("i",txt,attrs) ;}

    public static String h1(String txt) { return h1(txt,"") ; }
    public static String h1(String txt,String attrs) { return markup("h1",txt,attrs) ;}
    public static String h2(String txt) { return h2(txt,"") ; }
    public static String h2(String txt,String attrs) { return markup("h2",txt,attrs) ;}
    public static String h3(String txt) { return h3(txt,"") ; }
    public static String h3(String txt,String attrs) { return markup("h3",txt,attrs) ;}
    public static String h4(String txt) { return h4(txt,"") ; }
    public static String h4(String txt,String attrs) { return markup("h4",txt,attrs) ;}
    public static String h5(String txt) { return h5(txt,"") ; }
    public static String h5(String txt,String attrs) { return markup("h5",txt,attrs) ;}

    // -- br
    public static String br(String txt) { return br(txt,"") ; }
    public static String br(String txt,String attrs) { return markup("br",txt,attrs) ;}
    public static String br_() { return br_("") ; }
    public static String br_(String attrs) { return markupInline("br", attrs) ; }


    // -- markup core
    private static String markup(String nodeName, String txt, String attrs){ return String.format("<%s %s>%s</%s>",nodeName, attrs, txt, nodeName) ;}
    private static String markupInline(String nodeName, String attrs){ return String.format("<%s %s />",nodeName, attrs) ;}

    public static class Icon{
        public static final String TASK = i("","class=icon-tasks") ; // -- "<i class='icon-tasks'></i>" ;
        public static final String ACTIVITY = i("","class=icon-calendar") ; // -- "<i class='icon-calendar'></i>" ;
        public static final String FEEDBACK = i("","class=icon-comment") ; // -- "<i class='icon-comment'></i>" ;
        public static final String FILE = i("","class=icon-file") ; // -- "<i class='icon-file'></i>" ;
        public static final String OBSERVER = i("","class=icon-eye-open") ;
        public static final String FAVORITE = i("","class=icon-star") ; // -- "<i class='icon-star'></i>" ;
        public static final String USER = i("","class=icon-user") ; // -- "<i class='icon-user'></i>" ;
        public static final String HOME = i("","class=icon-home") ; // -- "<i class='icon-home'></i>" ;
        public static final String TRASH = i("","class=icon-trash") ; // -- "<i class='icon-trash'></i>" ;
        public static final String PLUS = i("","class=icon-plus") ; // -- "<i class='icon-trash'></i>" ;

        //
//        public static final String TEAM = i("","class=icon-tower") ; // -- "<i class='icon-trash'></i>" ;

        public static String get(String type) {
            if("TASK".equals(type)){
                return TASK ;
            }
            else if("ACTIVITY".equals(type)){
                return ACTIVITY ;
            }
            else if("FEEDBACK".equals(type)){
                return FEEDBACK ;
            }
            else if("FILE".equals(type)){
                return FILE ;
            }
            else if("OBSERVER".equals(type)){
                return OBSERVER ;
            }
            else {
                return "" ;
            }
        }
    }

    // --
    public static String trueString(boolean statement, String trueText) {
        return trueString(statement,trueText,"") ;
    }
    public static String trueString(boolean statement, String trueText, String falseText) {
        return (statement?trueText:falseText) ;
    }
}