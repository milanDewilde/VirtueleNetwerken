<%@ Control Language="VB" AutoEventWireup="false" CodeFile="SearchBox.ascx.vb" Inherits="UserControls_Skin_SearchBox" %>
<div id="section_searchbox">
    <div id="searchboxes" class="row collapse">
        <asp:Panel ID="pnlSearchBox" runat="server">
            <span class="small-10 columns"><input type="search" size="40" class="textbox" id="searchbox" onkeypress="javascript:presssearchkey(event);" /></span>
            <span class="small-2 columns"><input id="searchbutton" type="button" value='<asp:Literal ID="litContentText_Search" runat="server" Text="<%$ Resources: Kartris, ContentText_Search%>" />'
                class="button prefix" onclick="javascript: submitsearchbox()" /></span>
            <div class="spacer">
            </div>
            <script type="text/javascript">
                function submitsearchbox() {
                    window.location.href = document.getElementById('baseTag').href + 'Search.aspx?strSearchText=' + document.getElementById('searchbox').value.replace(/ /gi, "+");
                }
                function presssearchkey(e) {
                    if (typeof e == 'undefined' && window.event) { e = window.event; }
                    if (e.keyCode == 13) {
                        document.getElementById('searchbutton').click();
                        return false;
                    }
                }
            </script>
        </asp:Panel>
    </div>
</div>