<!DOCTYPE>
<html>
<head>
    <%--<!-- Bootstrap Core CSS -->--%>
    <%--<link href="css/bootstrap.min.css" rel="stylesheet">--%>

    <%--<!-- Custom CSS -->--%>
    <%--<link href="css/sb-admin-2.css" rel="stylesheet">--%>

    <%--<!-- Custom Fonts -->--%>
    <%--<link href="font-awesome-4.1.0/css/font-awesome.min.css" rel="stylesheet" type="text/css">--%>


    <!-- jQuery Version 1.11.0 -->
    <script src="/theme/2/js/jquery-1.11.0.js"></script>
    <%--<script src="/html/js/jquery.form.js"></script>--%>

    <script src="/html/tapmodo-Jcrop-1902fbc/js/jquery.Jcrop.min.js"></script>
    <link rel="stylesheet" href="/html/tapmodo-Jcrop-1902fbc/css/jquery.Jcrop.css" type="text/css"/>

    <meta http-equiv="Content-Type" content="text/html; charset=utf-8">
    <title>Image Crop</title>
</head>
<body>
<div>

    <form id="fileupload" method="post" action="photoAction.jsp" enctype="multipart/form-data">
        <input type="file" name="file" onchange="javascript:readUrl(this);"/>
        <input type="submit" value="Submit" id="CropButton"/>
    <br>
        <label><input type="text" size="4" id="x" name="cropX" readonly style="color:silver"/></label>
        <label><input type="text" size="4" id="y" name="cropY" readonly style="color:silver"/></label>
        <label><input type="text" size="4" id="w" name="cropW" readonly style="color:silver"/></label>
        <label><input type="text" size="4" id="h" name="cropH" readonly style="color:silver"/></label>
    </form>
    <%--<div id="progress">--%>
        <%--<div id="bar"></div>--%>
        <%--<div id="percent">0%</div>--%>
    <%--</div>--%>
    <%--<div id="message"></div>--%>
</div>
<div id="cropbox">
    <%--<img src="#" height="300" border="1" onerror="this.src='/html/images/file_icon.png'"/>--%>
</div>
<div id="output" height="100"></div>
<script>
    $(document).ready(function(){});
    function showCoords(c) {
        // get image natural height/width for server site crop image.
        var imageheight = document.getElementById('cropimg').naturalHeight;
        var imagewidth = document.getElementById('cropimg').naturalWidth;
        var xper = (c.x * 100 / $('#cropimg').width());
        var yper = (c.y * 100 / $('#cropimg').height());
        var wPer = (c.w * 100 / $('#cropimg').width());
        var hper = (c.h * 100 / $('#cropimg').height());

        var actX = (xper * imagewidth / 100);
        var actY = (yper * imageheight / 100);
        var actW = (wPer * imagewidth / 100);
        var actH = (hper * imageheight / 100);
        jQuery('#x').val(parseInt(actX));
        jQuery('#y').val(parseInt(actY));
        jQuery('#w').val(parseInt(actW));
        jQuery('#h').val(parseInt(actH));
    }

    function loadImage() {
        var w = 100;
        var h = 100;
        var W = $('#cropimg').width();
        var H = $('#cropimg').height();
        var x = W / 2 - w / 2;
        var y = H / 2 - h / 2;
        var x1 = x + w;
        var y1 = y + h;

        jQuery('#cropimg').Jcrop({
            onChange: showCoords,
            onSelect: showCoords,

            setSelect: [ x, y, x1, y1 ], minSize: [ 100, 100 ] // use for crop min size
            , aspectRatio: 1 / 1    // crop ration
        });
    }

    function readUrl(obj) {
        $('#cropbox').html("");
        if (obj.files && obj.files[0]) {
            var reader = new FileReader();
            reader.onload = function (e) {
                $('#cropbox').append($("<img/>",{'id':"cropimg",'src': e.target.result,'height':'300px','onerror':"this.src='/html/images/file_icon.png'"}));
                loadImage();
            }
            reader.readAsDataURL(obj.files[0]);
        }
    }
</script>
</body>
</html>