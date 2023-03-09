$(window).ready(function () {
    window.addEventListener('message', function (event) {
    let data = event.data
		if (data.action == "teammenu" && data.show) {
			$('.teamselection').show();
		}
		if (data.action == "teammenu" && !data.show) {
			$('.teamselection').hide();
		}
	})
})

$(document).ready(function() {
	$('.teamselection').hide();

	$("#OPFOR").click(function() {
		$('.teamselection').hide();
		console.log("WORKING: OPFOR");
		$.post('https://WarV/exit');
		$.post('https://WarV/opfor');
	});
	$("#BLUFOR").click(function() {
		$('.teamselection').hide();
		console.log("WORKING: BLUFOR");
		$.post('https://WarV/exit');
		$.post('https://WarV/blufor');
	});
	$("#SPECTATOR").click(function() {
		$('.teamselection').hide();
		console.log("WORKING: SPECTATOR");
		$.post('https://WarV/exit');
		$.post('https://WarV/spectator');
	});
});

