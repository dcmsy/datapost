var editor;
KindEditor.ready(function(K) {
    editor = K.create('#editor', {
        width : '650px',
        height : '240px',
        resizeType : 1,
        cssPath : '/kindeditor/plugins/code/prettify.css',
        uploadJson : '/blog/editor',
        allowPreviewEmoticons : false,
        allowImageUpload : true,
        items : [
            'undo', 'redo', '|', 'preview', 'print', 'template', 'code', 'cut', 'copy', 'paste',
            'plainpaste', 'wordpaste', '|', 'justifyleft', 'justifycenter', 'justifyright',
            'justifyfull', 'insertorderedlist', 'insertunorderedlist', 'indent', 'outdent', '|',
            'subscript', 'superscript', 'clearhtml', 'quickformat', 'selectall', 'source', '/',
            'formatblock', 'fontname', 'fontsize', '|', 'forecolor', 'hilitecolor', 'bold',
            'italic', 'underline', 'strikethrough', 'lineheight', 'removeformat', '|', 'image',
            'flash', 'media', 'table', 'hr', 'emoticons', 'baidumap', 'pagebreak',
            'anchor', 'link', 'unlink', '|', 'about', 'fullscreen'
        ],
        afterCreate : function() { 
            this.sync(); 
        }, 
        afterBlur:function(){ 
            this.sync(); 
        }
    });
});