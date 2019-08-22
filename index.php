<?php

get_header(); ?>

<?php
			if ( have_posts() ) :

				/* Start the Loop */
				while ( have_posts() ) : the_post();

					the_content();


				endwhile;

				

			endif;
			?>

<?php get_footer();
