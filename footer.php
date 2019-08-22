<div class="loading" id="loading">Loading&#8230;</div>

<?php wp_footer(); ?>

<?php if(get_the_ID()==62) { ?>
<script src="<?php echo get_template_directory_uri(); ?>/js/jquery-1.12.4.js"></script>
<?php } else { ?>
<script type="text/javascript" src="<?php echo get_template_directory_uri(); ?>/js/jquery.min.js"></script> 
<?php } ?>


<!-- <script src="<?php echo get_template_directory_uri(); ?>/js/jquery.multiselect.js"></script> -->

<!-- <script src="https://cdnjs.cloudflare.com/ajax/libs/moment.js/2.10.6/moment.min.js"></script>  -->
<script src="<?php echo get_template_directory_uri(); ?>/js/moment.min.js"></script>
<script src="<?php echo get_template_directory_uri(); ?>/js/datepicker.js"></script>

<script src="<?php echo get_template_directory_uri(); ?>/js/jquery.colorbox.js"></script>
<script src="<?php echo get_template_directory_uri(); ?>/js/jquery.validate.min.js"></script> 
<script src="<?php echo get_template_directory_uri(); ?>/js/jquery.validate.unobtrusive.min.js"></script>  
<script src="<?php echo get_template_directory_uri(); ?>/js/registration.js"></script>
<script src="<?php echo get_template_directory_uri(); ?>/js/bootstrap-datetimepicker.min.js"></script>
<script src="<?php echo get_template_directory_uri(); ?>/js/sweetalert2.js"></script>
<script src="https://cdnjs.cloudflare.com/ajax/libs/popper.js/1.11.0/umd/popper.min.js" integrity="sha384-b/U6ypiBEHpOf/4+1nzFpr53nxSS+GLCkfwBdFNTxtclqqenISfwAzpKaMNFNmj4" crossorigin="anonymous"></script>
<script src="<?php echo get_template_directory_uri(); ?>/js/bootstrap.min.js"></script> 
<!-- <script src="https://cdnjs.cloudflare.com/ajax/libs/jquery/1.12.4/jquery.min.map"></script> -->


<script src="<?php echo get_template_directory_uri(); ?>/js/jquery-ui.js"></script>
  <script src="<?php echo get_template_directory_uri(); ?>/js/moment.min.js"></script>
  <script src="<?php echo get_template_directory_uri(); ?>/js/fullcalendar.js"></script>
 <script src="<?php echo get_template_directory_uri(); ?>/js/scheduler.min.js"></script>

<script src="https://cdnjs.cloudflare.com/ajax/libs/bootstrap-select/1.12.4/js/bootstrap-select.js"></script>
<?php if(get_the_ID()!=60) { ?>
<script src="<?php echo get_template_directory_uri(); ?>/js/common.js"></script>
<?php } ?>

<script type="text/javascript">
var ajaxurl = '<?php echo get_admin_url(); ?>admin-ajax.php';

	/*window.setTimeout(function() {
    $(".alert").fadeTo(500, 0).slideUp(500, function(){
        $(this).remove(); 
    });
}, 6000);*/

</script>
<script type="text/javascript">

$(".notification").click(function(e) {
   e.stopPropagation();
});
 $('body').click(function(evt){    
 	$('.notif').hide();  
});
</script>

</body>
</html>