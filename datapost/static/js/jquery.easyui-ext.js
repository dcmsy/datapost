function S4() {
	return (((1 + Math.random()) * 0x10000) | 0).toString(16).substring(1);
}
function __create_indentity_id__() {
	return "UUID-"
			+ (S4() + S4() + "-" + S4() + "-" + S4() + "-" + S4() + "-" + S4()
					+ S4() + S4());
}

(function($) {
	/**
	 * 添加表单页面弹窗
	 * 
	 * @param {}
	 *            options
	 */

	var form_submit = function(type, dl, opts, id) {
		winform = $(opts.form);
		winform.form('submit', {
			onSubmit : function() {
				var isValid = $(this).form('validate');
				if (!isValid) {
					$.messager.progress('close'); // 当form不合法的时候隐藏工具条
				}
				return isValid; // 返回false将停止form提交
			},

			success : function(data) {
				try {
					var isjson = typeof(data) == "object"
							&& Object.prototype.toString.call(data)
									.toLowerCase() == "[object object]"
							&& !data.length;

					if (!isjson) {
						data = JSON.parse(data);
					}
				} catch (e) {
					return;
				}
				if (data.ret == 0) {
					if (type == 1) {
						dl.dialog('close');
						_onclose(opts.returl, "");
					} else {
						winform.form('custom_reset');
						_success();
					}
				} else {
					$.messager.alert('错误信息', data.msg, 'error');
				}
				var check_header = $(".datagrid-header-check input[type='checkbox']");
				if (check_header)
					check_header.attr("checked", false);
			}
		});
	};
	var create_iframe = function(id, dialog, opts) {
		var dgContent = dialog.find("div.dialog-content");
		dgContent.css("overflow", "hidden");
		var iframe = document.createElement("iframe");
		iframe.id = id;
		iframe.style.width = "100%";
		iframe.style.height = "100%";
		iframe.style.border = "0";
		iframe.frameborder = "0";
		iframe.src = opts.url;
		dgContent[0].appendChild(iframe);
	}
	var __windows_close_params__ = "";
	var id = __create_indentity_id__();
	$.window = function(options) {
		var opts = $.extend({}, $.window.defaults, options || {});

		var dl = $("#" + id);
		var def_butn = [{
					text : "保 存",
					iconCls:"&#xe645;",
					handler : function() {
						form_submit(1, dl, opts, id);
					}
				}, {
					text : "保存并继续",
					iconCls:"&#xf0154;",
					handler : function() {
						form_submit(2, dl, opts, id);
					}
				}, {
					text : "关 闭",
					iconCls:"&#xe616;",
					handler : function() {
						dl.dialog('destroy');
						if (opts.close_refresh) {
							_force_close();
						} else {
							_onclose(opts.returl, "");
							var check_header = $(".datagrid-header-check input[type='checkbox']");
							if (check_header)
								check_header.attr("checked", false);
						}
					}
				}];
		if (!opts.hasbutton) {
			def_butn = '';
		}
		if (!dl.length) {

			dl = $("<div id=" + dl + "></div>").appendTo("body");
			if (opts.iframe) {
				opts.url = opts.href;
				opts.href = "";
			}
			dl.dialog($.extend({}, opts, {
						onClose : function() {
							if (opts.iframe) {
								$.window.frame().find("body").empty();
							}
							dl.dialog('destroy');
							if (opts.close_refresh) {
								_force_close();
							}
						},
						buttons : opts.buttons || def_butn
					}));
			if (opts.iframe) {
				create_iframe(id, dl, opts);
			}
		} else {
			dl.dialog('refresh', opts.href);
		}
		dl.dialog('open');
		__windows_close_params__ = dl;
	}
	$.window.close = function() {
		var dl = __windows_close_params__;
		dl.dialog('destroy');
	}
	$.window.frame = function() {
		var frame = $(window.frames[id].document);
		return frame;
	}

	$.window.defaults = $.extend({}, $.fn.dialog.defaults, {
				title : "新窗口",
				iconCls : '&#xf0131;',
				width : 450,
				height : 300,
				closed : false,
				cache : false,
				href : '',
				modal : true,
				returl : '',
				form : 'form',
				dialog : 'dl',
				iframe : false,
				hasbutton : true,
				close_refresh : false
			})
})(jQuery);
(function($) {
	/**
	 * 选择弹出
	 * 
	 * @param {}
	 *            options
	 */
	var __showDialog_close_params__ = "";
	$.showDialog = function(options) {
		var opts = $.extend({}, $.showDialog.defaults, options || {});
		var id = __create_indentity_id__();
		var dl = $("#" + id);
		if (!dl.length) {
			dl = $("<div id=" + dl + "></div>").appendTo("body");
			dl.dialog($.extend({}, opts, {
						onClose : function() {
							dl.dialog('destroy');
						},
						buttons : opts.buttons || [{
							text : "确 定",
							handler : function() {
								var gd = $("#common-grid");
								if (!gd.length)
									gd = $(".datagrid-view table");
								var data = gd.datagrid('getSelections');
								var result = {};
								var ids = [];
								var texts = [];
								if (data.length == 0) {
									$.messager.alert("提示信息", "请至少选择一条数据",
											'info');
									return;
								}
								$.each(data, function(i) {
											var id = data[i][opts.idFiled];
											ids.push(id);
											var text = data[i][opts.textFiled];
											texts.push(text);
										})
								result[opts.idFiled] = ids.join(",");
								result[opts.textFiled] = texts.join(",");
								opts.handler(result, data);
								dl.dialog('destroy');
							}
						}, {
							text : "关 闭",
							handler : function() {
								dl.dialog('destroy');
							}
						}]
					}));
		} else {
			dl.dialog('refresh', opts.href);
		}
		dl.dialog('open');
		__showDialog_close_params__ = dl;
	}
	$.showDialog.close = function() {
		var dl = __showDialog_close_params__;
		dl.dialog('destroy');
	}
	$.showDialog.defaults = $.extend({}, $.fn.dialog.defaults, {
				title : "选择窗口",
				iconCls : '&#xf0161;',
				width : 450,
				height : 300,
				closed : false,
				cache : false,
				checkbox : false,
				href : '',
				modal : true,
				idFiled : 'id',
				textFiled : 'name',
				onClose : function() {
				}
			})
})(jQuery);
/**
 * 查询、高级查询
 */
(function($) {
	$.query = function(options) {
		var opts = $.extend({}, options || {});
		var form = opts.form;
		var param = {};
		$(form).find('input').each(function() {
					var name = $(this).attr('name');
					if (name == undefined)
						return;
					var val = "";
					if (!$(this).hasClass('searchbox-prompt')) {
						val = $(this).val();
					}
					if ($(this).hasClass('datebox-f')) {
						name = $(this).attr('comboname');
						val = $(this).datebox('getValue');
					} else if ($(this).hasClass('combogrid-f')) {
						name = $(this).attr('comboname');
						val = $(this).combogrid('getValue');
					} else if ($(this).hasClass('combobox-f')) {
						name = $(this).attr('comboname');
						val = $(this).combobox('getValue');
					} else if ($(this).hasClass('easyui-searchbox')) {
						name = $(this).attr('searchboxname');
						val = $(this).searchbox('getValue');
					}
					param[name] = val;
				});
		return param;
	}
	/**
	 * 高级查询
	 * 
	 * @param {}
	 *            options
	 */
	$.queryMore = function(options) {
		var opts = $.extend({}, $.queryMore.defaults, options || {});
		var dlq = $("#dl-query");

		if (!dlq.length) {
			dlq = $("<div id=\"dl-query\"></div>").appendTo("body");
			dlq.dialog($.extend({}, opts, {
				buttons : opts.buttons || [{
					text : "查 询",
					iconCls:'&#xf012c;',
					handler : function() {
						dlq.dialog('close');
						var param = {};
						dlq.find('.query').each(function() {
									var name = $(this).attr('name');
									var val = $(this).val();
									if ($(this).hasClass('datebox-f')) {
										name = $(this).attr('comboname');
										val = $(this).datebox('getValue');
									} else if ($(this).hasClass('combogrid-f')) {
										name = $(this).attr('comboname');
										val = $(this).combogrid('getValue');
									} else if ($(this).hasClass('combobox-f')) {
										name = $(this).attr('comboname');
										val = $(this).combobox('getValue');
									}
									param[name] = val;
								});
						opts.handler(param);
					}
				}, {
					text : "取 消",
					iconCls:'&#xf013a;',
					handler : function() {
						dlq.dialog('close');
					}
				}]
			}));
		}
		dlq.dialog('open');
	}
	$.queryMore.defaults = $.extend({}, $.fn.dialog.defaults, {
				title : "高级查询",
				iconCls : '&#xf00c3;',
				width : 500,
				height : 300,
				closed : false,
				cache : false,
				checkbox : false,
				href : '',
				modal : true
			})
})(jQuery);

/**
 * 删除、批量删除
 * 
 * @title : 提示框标题
 * @info : 提示信息
 * @href : 请求地址
 * @params : 参数
 * @returl : 删除后返回地址
 * @handler:删除后回调方法
 */
(function($) {
	$.deletes = function(options) {
		var opts = $.extend({}, $.deletes.defaults, options || {});
		var url = opts.href;
		var checked = "";
		var is_exits = false;
		var params = opts.params;
		var $grid = $(opts.grid);
		// params为空情况处理
		if (params.length == 0) {
			// 如果存在grid表格
			if ($grid.length)
				checked = $grid.datagrid('getChecked');
			// 截取url，获取是否有附加参数
			var param = url.split("?");
			// 此处两种情况处理，批量时params为ids=,单个信息删除时为id='123'
			params = param.length > 0 ? param[1] : "";
			url = param[0];
			is_exits = checked && checked.length > 0;
			// 获取表格选择的行
			if (is_exits) {
				var ids = [];
				$.each(checked, function() {
							ids.push(this.id);
						});
				if (params == "ids=")
					params += ids.join(",");
			}
		}
		url = encodeURI(url);
		if (is_exits || (params.length != 0 && params != "ids=")) {

			$.messager.confirm(opts.title, opts.info, function(r) {
				if (r) {
					$.ajax({
						type : "POST",
						url : url,
						dataType : "json",
						data : params,
						error : function(XMLHttpRequest, textStatus,
								errorThrown) {
							if (XMLHttpRequest.status == 200) {
								$.messager.alert("错误信息", "很抱歉，您没有权限执行该操作",
										'error');
							} else {
								$.messager.alert("错误信息", "系统错误，请稍后重试", 'error');
							}
						},
						success : function(data) {
							var isjson = typeof(data) == "object"
									&& Object.prototype.toString.call(data)
											.toLowerCase() == "[object object]"
									&& !data.length;
							if (!isjson) {
								var data = JSON.parse(data);
							}
							if (data.ret == 0) {
								if (opts.handler) {
									opts.handler.call();
								} else {
									_onclose(opts.returl, $grid);
								}
								var check_header = $(".datagrid-header-check input[type='checkbox']");
								if (check_header)
									check_header.attr("checked", false);
							} else {
								$.messager.alert('错误信息', data.msg, 'error');
							}
						}
					});
				}

			});
		} else {
			$.messager.alert('提示信息', '请至少选择一条记录进行操作', 'info');
		}
	}
	$.deletes.defaults = {
		title : '删除信息',
		info : '您确定要删除吗？',
		href : '',
		params : '',
		returl : '',
		handler : '',
		grid : '.datagrid-view>table'
	}
})(jQuery);
/**
 * form 提交
 * 
 * @returl 提交成功后返回页面
 * @form 表单名称
 */
(function($) {
	$.form_submit = function(options) {
		var opts = $.extend({}, $.form_submit.defaults, options || {});
		var winform = $(opts.form);
		winform.form('submit', {
			success : function(data) {
				var isjson = typeof(data) == "object"
						&& Object.prototype.toString.call(data).toLowerCase() == "[object object]"
						&& !data.length;
				if (!isjson) {
					var data = JSON.parse(data);
				}
				if (data.ret == 0) {
					if (opts.returl) {
						if (opts.handler) {
							opts.handler.call();
						} else {
							window.location.href = opts.returl;
							try {
								window.event.returnValue = false;
							} catch (e) {
							};
						}
					} else {
						winform.form('custom_reset');
						if (opts.handler)
							opts.handler.call();
						else
							_success();
					}
				} else {
					$.messager.alert('错误信息', data.msg, 'error');
				}
			}
		});
	}
	$.form_submit.defaults = $.extend({}, $.fn.form.defaults, {
				returl : '',
				form : 'form',
				handler : ''
			});
})(jQuery);
/**
 * textarea limit
 */
(function($) {
	$.fn.extend({
		limit : function(limit, element) {

			var interval, f;
			var self = $(this);
			$(element).html("0");
			$(this).focus(function() {
						interval = window.setInterval(substring, 100);
					});

			$(this).blur(function() {
						clearInterval(interval);
						substring();
					});

			substringFunction = "function substring(){ var val = $(self).val();var length = val.length;if(length > limit){$(self).val($(self).val().substring(0,limit));}";
			if (typeof element != 'undefined')
				substringFunction += "if($(element).html() != limit-length){$(element).html((limit-length<=0)?'0':limit-length);}"

			substringFunction += "}";

			eval(substringFunction);

			substring();

		}
	});
})(jQuery);

function linkbtn(value, options) {
	var opt = options || {};
	var len = opt.option.length;
	var links = $("<div></div>");
	var arr = [];
	for (var i = 0; i < len; i++) {
		var op = opt.option[i];
		if (!op.hide){
			if (!op.title)
				op.title = "";
			arr
					.push('<a href="javascript:void(0)" style="color:#166DCC;text-decoration: none;margin:0 2px;"');
			arr.push(' title="' + op.title + '"');
			if (op.onclick) {
				arr.push(' onclick=' + op.onclick + '("' + value + '")');
			}
			arr.push('>');
			arr.push('<i class="icon iconfont">');
			arr.push(op.icon);
			arr.push('</i>');
			if (op.text) {
				arr.push(op.text);
			}
			arr.push('</a>');
		}
	}
	var html = arr.join("");
	$(html).appendTo(links);
	return links.html();
}

/**
 * 成功后执行的动作
 */
function _success(msg) {
	var info = msg;
	if (!msg)
		info = '操作成功';
	if ($('.alert').html() == null) {
		$(".table_form")
				.before("<div class='alert alert-success' style='display:none'>"
						+ info + "</div>");
	}
	if (!msg) {
		$('.alert').slideDown(300).delay(800).slideUp(900);
	} else {
		$('.alert').slideDown(300).delay(1500).slideUp(900);
	}
}
function _force_close() {
	window.location.reload();
}

/**
 * 关闭刷新事件
 */
function _onclose(returl, target) {
	var grid = $('.datagrid-view>table');
	var tree = $(".tree");

	if (target != "")
		grid = target;
	if (returl) {
		window.location.href = returl;
	} else if (grid.length && tree.length) {
		grid.datagrid('reload');
		// tree.tree('reload');
	} else if (grid.length) {
		grid.datagrid('reload');
	} else if (tree.length) {
		// tree.tree('reload');
		window.location.reload();
	} else {
		window.location.reload();
	}
}
/**
 * 列表页面默认值重写
 */
$.extend($.fn.datagrid.defaults, {
			fitColumns : true,
			pageList : [10, 30, 50, 100],
			iconCls : "&#xf0161;",
			rownumbers : true,
			fit : true,
			pagination : true,
			striped : false,
			checkOnSelect : true,
			autoRowHeight : false,
			showPageList : false
		});
/**
 * tree扩展，获取level
 */
$.extend($.fn.tree.methods, {
			getLevel : function(jq, target) {
				var l = $(target).parentsUntil("ul.tree", "ul");
				return l.length + 1;
			}
		});
$.extend($.fn.form.methods, {
	custom_reset : function(jq) {
		return jq.each(function(target) {
					$('input,select,textarea', target).each(function() {
						var t = this.type, tag = this.tagName.toLowerCase();
						var readonly = $(this).attr("readonly");
						var disabled = $(this).attr("disabled");
						if ((t == 'text' || t == 'password' || tag == 'textarea')
								&& !readonly && !disabled) {
							this.value = '';
							if (tag == 'textarea')
								$(this).next().html("100");
						} else if (t == 'file') {
							var file = $(this);
							file.after(file.clone().val(''));
							file.remove();
						}

					});
				});
	}
});
/**
 * grid 行扩展
 */

/**
 * 验证扩展
 */
$.extend($.fn.validatebox.defaults.rules, {
	remote : {
		validator : function(value, param) {
			var postdata = {};
			postdata[param[1]] = value;
			var m_result = $.ajax({
						type : "POST",// http请求方式
						url : param[0], // 服务器段url地址
						data : postdata, // 发送给服务器段的数据
						dataType : "type", // 告诉JQuery返回的数据格式
						async : false
					}).responseText;
			if (m_result == "false") {
				$.fn.validatebox.defaults.rules.remote.message = param[2];
				return false;
			} else {
				return true;
			}
		},
		message : '已存在该数据，请修正'
	},
	equalTo : {
		validator : function(value, param) {
			return value != "" && value == $(param[0]).val();
		},
		message : '两次输入的不一致'
	},
	number : {
		validator : function(value, param) {
			return /^\d+$/.test(value);
		},
		message : '请输入数字'
	},
	safefilter : {
		validator : function(value, param) {
			return /^[\u4E00-\u9FA5\w]+$/.test(value);
		},
		message : '输入包含非法字符，请修正。'
	},
	filter : {
		validator : function(value, param) {
			var pattern = new RegExp("[%`~@|<>]");
			return value.match(pattern) == null ? true : false;
		},
		message : '输入包含非法字符，请修正'
	},
	maxLength : {
		validator : function(value, param) {
			var reg = /[\n|\r]/g
			var len = value.length;
			if (reg.test(value)) {
				len = len + 2;
			}
			return len <= param[0];
		},
		message : '最大长度不能超过 {0} 个字符.'
	},
	minLength : {
		validator : function(value, param) {
			return value.length >= param[0];
		},
		message : '最小长度不能少于 {0} 个字符。'
	},
	words : {
		validator : function(value, param) {
			return /^[a-zA-Z0-9_]{1,}$/.test(value);
		},
		message : '只允许字母、数字及下划线。'
	},
	pswfilter : {
		validator : function(value, param) {
			if (((value.match(/^.*[\~\!\@\#\^\&\*\_\-\+\=]+.*$/) == null) || (value
					.match(/^.*[a-z]+.*$/) == null))
					|| ((value.match(/^.*[A-Z]+.*$/) == null) || (value
							.match(/^.*[0-9]+.*$/) == null))) {
				return false;
			} else {
				return true;
			}
		},
		message : '密码必须同时包含大写字母、小写字母、数字、特殊字符（~、!、@、#、^、&、*、_、-、+、=）'

	},
	ip : {
		validator : function(value, param) {
			var exp = /^(\d{1,2}|1\d\d|2[0-4]\d|25[0-5])\.(\d{1,2}|1\d\d|2[0-4]\d|25[0-5])\.(\d{1,2}|1\d\d|2[0-4]\d|25[0-5])\.(\d{1,2}|1\d\d|2[0-4]\d|25[0-5])$/;
			return value.match(exp) == null ? false : true;
		},
		message : 'ip地址不符合规范'
	},
	numRange : {
		validator : function(value, param) {
			return value >= param[0] && value <= param[1];
		},
		message : '输入的数字范围不符合规范'
	},
	regx : {
		validator : function(value, param) {
			return param[0].test(value);
		},
		message : '{1}'
	}

});
/**
 * 引入my97时间控件
 */
(function($) {
	$.fn.my97 = function(options, params) {
		if (typeof options == "string") {
			return $.fn.my97.methods[options](this, params);
		}
		options = options || {};
		if (!WdatePicker) {
			alert("未引入My97js包！");
			return;
		}
		return this.each(function() {
					var data = $.data(this, "my97");
					var newOptions;
					if (data) {
						newOptions = $.extend(data.options, options);
						data.opts = newOptions;
					} else {
						newOptions = $.extend({}, $.fn.my97.defaults, $.fn.my97
										.parseOptions(this), options);
						$.data(this, "my97", {
									options : newOptions
								});
					}
					$(this).addClass('Wdate').click(function() {
								WdatePicker(newOptions);
							});
				});
	};
	$.fn.my97.methods = {
		setValue : function(target, params) {
			target.val(params);
		},
		getValue : function(target) {
			return target.val();
		},
		clearValue : function(target) {
			target.val('');
		}
	};
	$.fn.my97.parseOptions = function(target) {
		return $.extend({}, $.parser.parseOptions(target, ["el", "vel",
								"weekMethod", "lang", "skin", "dateFmt",
								"realDateFmt", "realTimeFmt", "realFullFmt",
								"minDate", "maxDate", "startDate", {
									doubleCalendar : "boolean",
									enableKeyboard : "boolean",
									enableInputMask : "boolean",
									autoUpdateOnChanged : "boolean",
									firstDayOfWeek : "number",
									isShowWeek : "boolean",
									highLineWeekDay : "boolean",
									isShowClear : "boolean",
									isShowToday : "boolean",
									isShowOthers : "boolean",
									readOnly : "boolean",
									errDealMode : "boolean",
									autoPickDate : "boolean",
									qsEnabled : "boolean",
									autoShowQS : "boolean",
									opposite : "boolean"
								}]));
	};
	$.fn.my97.defaults = {
		dateFmt : 'yyyy-MM-dd HH:mm:ss'
	};

	$.parser.plugins.push('my97');
})(jQuery);


(function($) {
	$.fn.searchbox.defaults = $.extend({}, $.fn.searchbox.defaults, {
		height : 28
	});
	$.fn.combo.defaults = $.extend({}, $.fn.combo.defaults, {
		height : 28
	});
	$.fn.combobox.defaults = $.extend({}, $.fn.combobox.defaults, {
		height : 28
	});
	$.fn.combotree.defaults = $.extend({}, $.fn.combotree.defaults, {
		height : 28
	});
	$.fn.combogrid.defaults = $.extend({}, $.fn.combogrid.defaults, {
		height : 28
	});
	$.fn.progressbar.defaults = $.extend({}, $.fn.progressbar.defaults, {
		height : 14
	});
	//$.fn.combogrid.defaults

})(jQuery);


(function( $ ){
	$.rpc = function(method, url, req) {
	  var json="{}";
	  try{
	     json=$.toJSON(req);
	  }catch(e){
       json="{}";
	  }
	  var res = $.ajax({type : (method=='get'?'GET':'POST'), url:url,async: false,cache: false,data : {"json":json}});
		if (res) {
		   try{
		      return $.evalJSON(res.responseText);
		   }catch(e){
		      return {};
		   }
		}
	  return {};
	};
})( jQuery );