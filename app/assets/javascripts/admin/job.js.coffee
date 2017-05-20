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
						element.closest("tr").find(".report_progress_cell").html(response.percent + "%")
						if response.status == null
							clearInterval element.timer
			, 5000
