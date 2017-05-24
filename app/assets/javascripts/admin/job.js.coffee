$ ->
	$("#index_table_reports .report_data_cell").each (index, element)->
		element = $(element)
		status = element.data("status")
		job_id = element.data("job-id")
		if status != "completed" && status != "failed"
			element.timer = setInterval ()->
				$.ajax "/jobs/status.json",
					data:
						job_id: job_id
					success: (response)->
						view = "<span class='status_tag " + status + "'>" + response.status + " " + response.percent + "%</span>"
						element.closest("tr").find(".report_progress_cell").html(view)
						if response.status == "completed"
							clearInterval element.timer
			, 5000
