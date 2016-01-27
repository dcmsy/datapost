$(function(){
	$('form').submit(function(){
		$.post($(this).attr('action'), $(this).serialize(), function(data){
			alert(data.back);
		});
		return false;
	});
});