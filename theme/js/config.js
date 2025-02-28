/*
	Dopetrope 2.0 by HTML5 UP
	html5up.net | @n33co
	Free for personal and commercial use under the CCA 3.0 license (html5up.net/license)
*/

window._skel_config = {
	preset: 'standard',
	prefix: '/theme/css/style',
	resetCSS: true,
	breakpoints: {
		'desktop': {
			grid: {
				gutters: 50
			}
		}
	}
};

window._skel_panels_config = {
	preset: 'standard'
};

jQuery(function() {
	$('#nav > ul').dropotron({
		offsetY: -17,
		offsetX: -1,
		mode: 'fade',
		noOpenerFade: true,
		detach: false
	});

});


// ========================================
// 一些自定义操作
// ========================================

// 代码块支持复制 , 最大/小化
function codeBlockSupport() {
	// 复制代码块
	var copyCode = function() {
		var code = $(this).parent().next().text();
		var $temp = $("<textarea>");
		$("body").append($temp);
		$temp.val(code).select();
		document.execCommand("copy");
		$temp.remove();
		alert('代码已复制到剪贴板');
	};
	$(".code-block .copy").click(copyCode);

	// 最大化代码块
	var maxCode = function() {
		var $codeBlock = $(this).parent().next();
		if ($codeBlock.hasClass("max")) {
			$codeBlock.removeClass("max");
		} else {
			$codeBlock.addClass("max");
		}
	};
	$(".code-block .max").click(maxCode);
}






