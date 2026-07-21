const urlParams = new URLSearchParams(window.location.search);
const pageid = urlParams.get('pageid');

$('#' + pageid).addClass("active")