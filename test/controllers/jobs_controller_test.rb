require "test_helper"

class JobsControllerTest < ActionDispatch::IntegrationTest
	include ActiveJob::TestHelper
  
  test "status should return information of Active job" do
  	setup_customers
    assert_performed_with(job: ReportJob) do
	    basic_customer_report = FactoryGirl.create :basic_customer_report
	    job_id = basic_customer_report.background_job_id

	    get jobs_status_url(job_id: job_id, format: "json")
	    assert_response :success

	    response = JSON.parse @response.body
	    assert_equal "completed", response["status"]
	    assert_equal 0, response["percent"]
	  end
  end

end
