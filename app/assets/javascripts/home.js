// Place all the behaviors and hooks related to the matching controller here.
// All this logic will automatically be available in application.js.

function rankcolor(rank)
{
	if(rank == 1)
		return 0;
	else if (rank == 2)
		return 2;
	else if (rank == 3)
		return 4;
	else if (rank <= 10)
		return 6;
	else
		return 7;
}

function showproblem(pid)
{
		$.ajax({
			url:'/problems/'+pid+'.json',
			method: 'get',
			success: function (json)
			{
				$('.solveboard .key').show();
				$('.cell-selected').addClass('cell');
				$('.cell-selected').removeClass('.cell-selected');
				$('#probcell-'+pid).removeClass('cell');
				$('#probcell-'+pid).addClass('cell-selected');
				$('#solve .information .name').html(json.problem.name+'  <a href="/problems/'+json.problem.id+'"><i class="pull-right icon-info-sign"></i></a>');
				if( json.problem.file.url)
				{
					$('#solve .information .file').html('<a href="'+json.problem.file.url+'">'+json.problem.file.url.split('/').pop()+'</a>');
				}
				else
				{
					$('#solve .information .file').html('');
				}
				$('#solve .information .hint').html(json.problem.hint);
				$('#solve .information .point').text(json.problem.point);
				$('#solve .information .point').show();
				$('#solve .key #num').val(json.problem.id);
			}
		});
}

$(function () {
	$("#tryform").bind('ajax:success', function(a,data,stat,xhr){
		var response = JSON.parse(xhr.responseText);
			if(response.result == 'ok')
			{
				alert("축하합니다! :-)");
			}
			else if(response.result == 'already')
			{
				alert("이미 푼 문제입니다. :-(");
			}
			else if(response.result == 'maker')
			{
				alert("출제자는 문제를 풀 수 없습니다. :-)");
			}
			else if(response.result == 'closed')
			{
				alert("대회가 종료되었습니다.");
			}
			else
			{
				alert("틀렸습니다. :-(");
			}
			setsolved();
			showranking();
		});
});
function setsolved()
{
	$.ajax({
		url:'/solved',
		method: 'get',
		success: function(json)
		{
			for (prob in json.solved)
			{
				pnum = json.solved[prob];
				$("#probcell-"+pnum).addClass('cell-solved');
			}
		}
	});
}

$(function(){
	setsolved();
	showranking();
	$('#refresh-ranking').click(function(){
		showranking();
	});
	setInterval( function(){ showranking() }, 10000 );
});


function showranking()
{
	$.ajax({
		url:'/ranking',
		method: 'get',
		beforeSend: function(){
			$("#score .top-players").text('Loading...');
		},
		success: function(json)
		{
			$("#score .top-players").html('')
			var count = 0;
			for (index in json.top)
			{
				count = count + 1;
				var user = json.top[index];
				if(count <= 10)
				{

				$("#score .top-players").append(
					'<div class=player>'+
						'<div class="rank color'+rankcolor(count)+'">'+count+'</div>'+
						'<div class="name">'+user.name+'</div>'+
						'<div class="score color'+rankcolor(count)+'">'+user.points+'</div>'+
					'</div>'
				);
				}
			}
			json.record.forEach(function (record)
			{
				var myrank = 0;
				var mypoint = 0;
				if (record.rank)
					myrank = record.rank;
				if (record.points)
					mypoint = record.points;
				$("#score .myscore .rank").text(myrank).addClass('color'+rankcolor(record.rank));
				$("#score .myscore .score").text(mypoint).addClass('color'+rankcolor(record.rank));
			});

		}
	});
}


