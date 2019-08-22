<style type="text/css">
	.removebtn {
    color: #fff;
    position: absolute;
    top: 0;
    right: 0;
    height: 0px !important;
    font-size: 20px !important;
    cursor: pointer;
    background: none;
    border: none;
    font-weight: 700;
	}
</style>

<?php 
$data = order();
// print_r($data);
?>
<script type="text/javascript">
	
	$(document).ready(function() {
		// var popTemplate = [
  //   '<div class="popover" style="max-width:600px;" >',
  //   '<div class="arrow"></div>',
  //   '<div class="popover-header">',
  //   '<button id="closepopover" type="button" class="close" aria-hidden="true">&times;</button>',
  //   '<h3 class="popover-title"></h3>',
  //   '</div>',
  //   '<div class="popover-content"></div>',
  //   '</div>'].join('');


        $('#calendar').fullCalendar({
        	header: {
			    right: 'month,agendaWeek,prev,next today'
			   },
			events: [
			  <?php echo $data;?>
			],

		  eventRender: function(event, element){
		  	
      //       element.append( "<button type='button' class='removebtn' aria-label='Close'><span aria-hidden='true'>&times;</span></button>" );
      //   	element.find("button .removebtn").click(function() {
      //   	$('#eventTitle').html(event.title);

		    // // Rebind the Remove button click handler
		    // $("#removeBtn").off('click').on('click', function(e) {
		    //     $('#calendar').fullCalendar('removeEvents', event._id);
		    // });

		    // $('#modalRemove').modal();
      //     $('#calendar').fullCalendar('removeEvents',event._id);
      //   });
		          element.popover({
		          	// template: popTemplate,
		              animation:true,
		              html : true, 
		              delay: 50,
		              content: event.service_name,
		              trigger: 'hover'
		          });
		         },
        	});
	        
    	});

</script>
<script type="text/javascript">
var ajaxurl = '<?php echo get_admin_url(); ?>admin-ajax.php';
</script>

 


