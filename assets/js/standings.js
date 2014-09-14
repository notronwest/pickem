$(document).ready(function() {
    $('#standings').dataTable({
    	paging: false,
    	searching: false,
    	order: [ 3, "desc"],
    	scrollX: true,
    	scrollY: true
    });
} );