module ProjectHelper
  
  def with_most_recent_commit(project)
    return if project.repo.nil?
    commit = project.find_commit_by_sha project.repo.branch("master")
    if commit
      commit.project = project.model # so that _Commit_ doesn't load project again
      yield commit
    end
  end
  
  def with_most_recent_release(project)
    release = @releases[project.id]
    if release
      release.project = project.model # so that _Release_ doesn't load project again
      yield release
    end
  end
  
  def with_most_recent_test_run(project)
    test_run = @test_runs[project.id]
    if test_run
      test_run.project = project.model # so that _TestRun_ doesn't load project again
      yield test_run
    end
  end
  
  def project_label(project)
    return '<b class="label unknown">&nbsp;</b>'.html_safe unless project
    "<b class=\"label #{project.color}\">#{h project.slug.gsub("_", " ")}</b>".html_safe
  end
  
end
