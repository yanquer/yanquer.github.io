
const targetHeadCSS = [
	// <link rel="stylesheet" href="/theme/css/alabaster.css" />
	// <link rel="stylesheet" href="/theme/css/style-update.css" />
	// "/theme/css/alabaster.css",
	// "/theme/css/style-update.css",
	"http://yanque.gitlab.yq.lc/yq-blog/theme/css/style-update.css",
	// "/theme/css/pygments_by_pydata.css",
];

const backLoading = () => {
	const targetHead = document.getElementsByTagName("head")[0];
	for (const one of targetHeadCSS) {
		let _style = document.createElement("link");
		_style.setAttribute("rel", "stylesheet");
		_style.setAttribute("type", "text/css");
		_style.setAttribute("href", one);
		targetHead.appendChild(_style);
		// targetHead.appendChild(document.createElement("style", {"href": one}));
	}
}

backLoading()



