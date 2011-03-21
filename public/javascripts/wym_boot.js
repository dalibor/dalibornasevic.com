jQuery(function() {
  jQuery(".wymeditor").wymeditor({
    basePath: "/javascripts/wymeditor/",
    iframeBasePath: "/javascripts/wymeditor/iframe/default/",
    skinPath: "/javascripts/wymeditor/skins/default/"
  });

    //jQuery('.wymeditor').wymeditor({
        ////stylesheet: 'styles.css',      //styles to load
        //postInit: function(wym) {

            ////add the 'Wrap' translation (used here for the dialog's title)
            //jQuery.extend(WYMeditor.STRINGS['en'], {
                //'Wrap': 'Wrap'
            //});

            ////construct the wrap button's html
            ////note: the button image needs to be created ;)
            //var html = "<li class='wym_tools_wrap'>"
                     //+ "<a href='#'"
                     //+ " title='Wrap'"
                     //+ " style='background-image:"
                     //+ " url(/javascripts/wymeditor/skins/default/icons.png)'>"
                     //+ "Wrap"
                     //+ "</a></li>";

            ////add the button to the tools box
            //jQuery(wym._box)
            //.find(wym._options.toolsSelector + wym._options.toolsListSelector)
            //.append(html);

            ////construct the unwrap button's html
            ////note: the button image needs to be created ;)
            //html = "<li class='wym_tools_unwrap'>"
                     //+ "<a href='#'"
                     //+ " title='Unwrap'"
                     //+ " style='background-image:"
                     //+ " url(/javascripts/wymeditor/skins/default/icons.png)'>"
                     //+ "Unwrap"
                     //+ "</a></li>";

            ////add the button to the tools box
            //jQuery(wym._box)
            //.find(wym._options.toolsSelector + wym._options.toolsListSelector)
            //.append(html);

            ////construct the dialog's html
            //html = "<body class='wym_dialog wym_dialog_wrap'"
               //+ " onload='WYMeditor.INIT_DIALOG(" + WYMeditor.INDEX + ")'"
               //+ ">"
               //+ "<form>"
               //+ "<fieldset>"
               //+ "<input type='hidden' class='wym_dialog_type' value='"
               //+ "Wrap"
               //+ "' />"
               //+ "<legend>Wrap</legend>"
               //+ "<div class='row'>"
               //+ "<label>Type</label>"
               //+ "<select class='wym_select_inline_element'>"
               //+ "<option selected value='abbr'>Abbreviation</option>"
               //+ "<option value='acronym'>Acronym</option>"
               //+ "<option value='cite'>Citation, reference</option>"
               //+ "<option value='code'>Code</option>"
               //+ "<option value='del'>Deleted content</option>"
               //+ "<option value='ins'>Inserted content</option>"
               //+ "<option value='span'>Generic</option>"
               //+ "</select>"
               //+ "</div>"
               //+ "<div class='row'>"
               //+ "<label>Title</label>"
               //+ "<input type='text' class='wym_title' value='' size='40' />"
               //+ "</div>"
               //+ "<div class='row row-indent'>"
               //+ "<input class='wym_submit wym_submit_wrap' type='button'"
               //+ " value='{Submit}' />"
               //+ "<input class='wym_cancel' type='button'"
               //+ "value='{Cancel}' />"
               //+ "</div>"
               //+ "</fieldset>"
               //+ "</form>"
               //+ "</body>";

            ////handle click event on wrap button
            //jQuery(wym._box)
            //.find('li.wym_tools_wrap a').click(function() {
                //wym.dialog( 'Wrap', null, html );
                //return(false);
            //});

            ////handle click event on unwrap button
            //jQuery(wym._box)
            //.find('li.wym_tools_unwrap a').click(function() {
                //wym.unwrap();
                //return(false);
            //});

        //},

        ////handle click event on dialog's submit button
        //postInitDialog: function( wym, wdw ) {

            ////wdw is the dialog's window
            ////wym is the WYMeditor instance

            //var body = wdw.document.body;

            //jQuery( body )
                //.find('input.wym_submit_wrap')
                //.click(function() {

                    //var tag   = jQuery(body).find('.wym_select_inline_element').val();
                    //var title = jQuery(body).find('.wym_title').val();

                    //wym.wrap( '<' + tag + ' title="' + title + '">', '</' + tag + '>' );
                    //wdw.close();

                //});
        //}

    //});
});
