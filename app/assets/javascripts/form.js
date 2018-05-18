document.addEventListener("turbolinks:load", function() {

  // Adds a new nested form
  // Finds all links with data-form-prepend (which contains the form to add)
  // changes name to timesstamp
  // and appends it to the element from data-target
  console.log('hi');
  $('[data-form-prepend]').click( function(e) {
      var obj = $( $(this).attr('data-form-prepend') );
      obj.find('input, select, textarea').each( function() {
        $(this).attr( 'name', function() {
          return $(this).attr('name').replace( 'new_record', Math.floor((new Date()).getTime()/10) );
        });
      });
      var target = $($(this).attr('data-target'));
      target.append(obj);
      return false;
    });

})
