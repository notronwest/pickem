$(document).ready(function() {
    $('#standings').dataTable({
    	paging: false,
    	searching: false,
    	order: [ 3, "desc"]
    });

    $('#weekResults').dataTable({
    	paging: false,
    	searching: false,
    	order: false
    });

    // handle the on draw event to push "tiebreaks" link to the top
    $('#standings').on('draw.dt', function(){
    	$("#fullResultsHeader").detach().insertBefore("#standings tbody tr:first-child");
    });
} );