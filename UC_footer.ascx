<%@ Control Language="vb" AutoEventWireup="false" CodeBehind="UC_footer.ascx.vb" Inherits="admintickets.UC_footer" %>
<script>


    $(document).ready(function () {
        $('.cellhover').mouseover(function () {
            var cellid = $(this).attr("id");
            //   console.log(cellid);

            var cellrow = cellid.substring(0, 1);
            //   console.log(cellrow);

            var cellnmb = cellid.substring(1, 3);
            //   console.log(cellnmb);

            $('.' + cellrow).css('background-color', '#fef8cc');
            $('#' + cellnmb).css('background-color', '#fef8cc');
        }),


            $('.cellhover').mouseout(function () {
                var cellid = $(this).attr("id");
                //      console.log(cellid);

                var cellrow = cellid.substring(0, 1);
                //     console.log(cellrow);

                var cellnmb = cellid.substring(1, 3);
                //      console.log(cellnmb);

                $('.' + cellrow).css('background-color', '#fff');
                $('#' + cellnmb).css('background-color', '#fff');
            });


        const urlParams = new URLSearchParams(window.location.search);
        const pageid = urlParams.get('pageid');

        if (pageid != null) {
            $('#nav' + pageid).addClass("active");
        } else {
            $('#nav0').addClass("active"); //***change to add url check?
        }



    });
    </script>