$(document).ready(function() {
    $('#standings').dataTable({
    	paging: false,
    	searching: false,
    	order: [ $("#standings > thead > tr").children("th").length - 1, "desc"],
    	scrollX: true
    });
} );