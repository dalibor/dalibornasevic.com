document.observe('dom:loaded', function(){
    //Event.observe(window, 'load', function() {
    
    $$('.delete').each(function(element){
    
        Event.observe(element, 'click', function(event){
			
if (confirm('Are you sure?')) {
    var f = document.createElement('form');
    f.style.display = 'none';
    this.parentNode.appendChild(f);
    f.method = 'POST';
    f.action = element.href.match(/(\d)\/delete/, '')[1];
	
    var m = document.createElement('input');
    m.setAttribute('type', 'hidden');
    m.setAttribute('name', '_method');
    m.setAttribute('value', 'delete');
    f.appendChild(m);
	
    var t = document.createElement('input');
    t.setAttribute('type', 'hidden');
    t.setAttribute('name', 'authenticity_token');
    t.setAttribute('value', _token);
    f.appendChild(t);

    f.submit();
};
//return false;

			

//		            return false;
					event.stop();
        })

        //$('tekst').observe('click', function() { alert('bbbbbbbbb')});

    })
});



