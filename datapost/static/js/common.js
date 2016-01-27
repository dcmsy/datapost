
// 表格行隔行变色函数
// 参数解释:
// tableId table的id值, 必选
// oddColor 行处于奇数位置的背景色,可选,默认白色
// evenColor 行处于偶数位置的背景色,可选,默认蓝色
// hoverColor 鼠标悬停与行时,行的背景色,可选,默认红色
// cursor 鼠标悬停与行时,光标的样式,可选,默认手型
function trChangeColor(tableId,oddColor,evenColor,hoverColor,cursor){
    var oddColor = arguments[1] || '#fff';
    var evenColor = arguments[2] || '#fafafa';
    var hoverColor = arguments[3] || '#f0f0f0';
    var cursor = arguments[4] || 'pointer';
    var tbody = document.getElementById(tableId).getElementsByTagName('tbody');
    for(var i=0;i<tbody.length;i++){
        var trs = tbody[i].getElementsByTagName('tr');
        for(var j=0;j<trs.length;j++){
            if((j % 2) == 0){
                trs[j].style.backgroundColor = oddColor;
                trs[j].onmouseout = function(){this.style.backgroundColor = oddColor;}
            }else{
                trs[j].style.backgroundColor = evenColor;
                trs[j].onmouseout = function(){this.style.backgroundColor = evenColor;}
            }
            trs[j].onmouseover = function(){this.style.backgroundColor = hoverColor ;this.style.cursor = cursor;}
        }
    }
} 


//设置区块的高度
//id为所要设置高度的区块id
//data为区块和窗口总高度的差距
//minHeight为想要为区块设定的最小宽度
function setHeight(id,data,minHeight){
    //当前窗口的高度
    var allheight = document.documentElement.clientHeight;
    if(allheight > data){
        var hh = allheight - data;
        if(hh>=minHeight) 
            $(id).height(allheight - data);
        else
            $(id).height(minHeight);
    }
}

//设置部门列表的显示隐藏
function orgOpt(){
    $("#orgOptLink").toggle(function(){
        $("#orgOptLink").html("<i class='iconfont'>&#xe6d7;</i>");
        $(".orgList").children(".deptTitle").hide();
        $(".orgList").children("#orgTree").hide();
        $(".orgList").width(30);
        $(".optList .optListContent").css("margin-left",'31px');

    },function(){
        $("#orgOptLink").html("<i class='iconfont'>&#xe6d4;</i>");
        $(".orgList").children(".deptTitle").show();
        $(".orgList").children("#orgTree").show();
        $(".orgList").width(225);
        $(".optList .optListContent").css("margin-left",'226px');
    });
}

//设置数据列表中checkbox的控制
//用.listData表示当前表格区域
function crlCheckbox(){
    $(".chk_all").click(function() {
        if($(this).attr('checked')){
            $(this).parents('.listData').find('.chk_item').attr('checked',true).parents('tr').addClass('tr_selected');
        }else{
            $(this).parents('.listData').find('.chk_item').attr('checked',false).parents('tr').removeClass('tr_selected');
        }
    });
    $(".chk_item").click(function() {
        var $chkitem = $(this).parents('.listData').find('.chk_item');
        var $chkall = $(this).parents('.listData').find('.chk_all');
        if($(this).attr('checked')){
            $(this).parents('tr').addClass('tr_selected')
            if($(this).parents('.listData').find('.chk_item:checked').length == $chkitem.length){
                 $chkall.attr('checked',true);
            }
        }else{
            $(this).parents('tr').removeClass('tr_selected')
            if($chkall.attr('checked')) $chkall.attr('checked',false);
        }
    });
}