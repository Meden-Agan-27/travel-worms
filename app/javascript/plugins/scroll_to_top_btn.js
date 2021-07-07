//Get the button:
const mybutton = document.getElementById("myBtn");

// add event listener to listen for click.
if(mybutton){
mybutton.addEventListener("click", topFunction);
}
// When the user scrolls down 20px from the top of the document, show the button


function scrollFunction() {
  if (document.body.scrollTop > 20 || document.documentElement.scrollTop > 20) {
    mybutton.style.display = "block";
  } else {
    mybutton.style.display = "none";
  }
}

// When the user clicks on the button, scroll to the top of the document
function topFunction() {
  document.body.scrollTop = 0; // For Safari
  document.documentElement.scrollTop = 0; // For Chrome, Firefox, IE and Opera
}


export { topFunction, scrollFunction };
