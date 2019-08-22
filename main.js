jQuery(document).ready(function(){
	var totals = 0;
	jQuery('.single_add_to_cart_button.gform_button').prop('disabled', true);
	jQuery('#total_quantity').html(totals);
	jQuery('.custom-meal-quantity select').on('change', function() {
		update_totals();
	});
	jQuery('.custom-meal-item select').on('change', function() {
		update_totals();
	});
});

function update_totals(){
	totals = 0;
	jQuery('.custom-meal-quantity').each(function(){
		var quantities = jQuery(this).find('select').val();
		var values = quantities.split("|");
		if(jQuery(this).css('display') != 'none'){
			totals += parseInt(values[0]);
		}
	});
	jQuery('#total_quantity').html(totals + ' oz');
	validate_form();
}

function validate_form(){
	if(is_invalid_form()){
		jQuery('.single_add_to_cart_button.gform_button').prop('disabled', true);
		jQuery('#limit_exceeded_text').hide();
	} else if(totals > 16){
		jQuery('.single_add_to_cart_button.gform_button').prop('disabled', true);
		jQuery('#limit_exceeded_text').show();
	} else{
		jQuery('.single_add_to_cart_button.gform_button').prop('disabled', false);
		jQuery('#limit_exceeded_text').hide();
	}
}

function is_invalid_form(){
	var is_valid = true;
	jQuery('.validate-required select').each(function(){
		if(jQuery(this).val().toLowerCase().indexOf('none') != -1){
			is_valid = false;
			return false;
		}
	});

	return !is_valid;
}
