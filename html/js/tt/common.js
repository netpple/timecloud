// -- LOCK FOR AJAX REQUEST / RESULT
var IS_SUMBIT = false ;
function lock(){ if(IS_SUMBIT)return IS_SUMBIT ;  IS_SUMBIT = true ; }
function unlock(){ IS_SUMBIT = false ; }

// --