import "bootstrap";
import { initStarRating } from '../plugins/init_star_rating';
import { topFunction, scrollFunction } from '../plugins/scroll_to_top_btn';

initStarRating();
if(document.getElementById("myBtn")) {
topFunction();
window.onscroll = function() {scrollFunction()};
}
