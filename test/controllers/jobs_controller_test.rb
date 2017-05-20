require "test_helper"

class JobsControllerTest < ActionDispatch::IntegrationTest
  
  test "status should return information of sidekiq job" do
    basic_customer_report = FactoryGirl.create :basic_customer_report
    job_id = basic_customer_report.background_job_id

    get jobs_status_url(job_id: job_id, format: "json")
    assert_response :success

    response = JSON.parse @response.body
    assert_equal "queued", response["status"]
    assert_equal 0, response["percent"]
  end

end
