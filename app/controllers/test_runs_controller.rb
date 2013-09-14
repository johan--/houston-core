class TestRunsController < ApplicationController
  before_filter :find_test_run
  
  def show
    render template: "project_notification/test_run", layout: "email"
  end
  
  def retry
    @test_run.retry!
    redirect_to @project.ci_server.last_build_url
  end
  
private
  
  def find_test_run
    @project = Project.find_by_slug!(params[:slug])
    @test_run = @project.test_runs.find_by_sha(params[:commit]) || (raise ActiveRecord::RecordNotFound)
  end
  
end
