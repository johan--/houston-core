class TicketPresenter
  include UrlHelper
  
  class OneOrMany
    
    def initialize(one_or_many)
      @one_or_many = one_or_many
    end
    
    def map(&block)
      if @one_or_many.respond_to?(:map)
        @one_or_many.map(&block)
      else
        yield @one_or_many
      end
    end
    
  end
  
  def initialize(tickets)
    @tickets = OneOrMany.new(tickets)
  end
  
  def as_json(*args)
    @tickets.map do |ticket|
      { id: ticket.id,
        projectId: ticket.project.unfuddle_id,
        projectSlug: ticket.project.slug,
        projectTitle: ticket.project.name,
        projectColor: ticket.project.color,
        number: ticket.number,
        summary: ticket.summary,
        verdict: ticket.verdict.downcase,
        verdictsByTester: ticket.verdicts_by_tester_index,
        queue: ticket.queue,
        committers: ticket.committers,
        deployment: ticket.deployment,
        age: ticket.age }
    end
  end
  
  def with_testing_notes
    @tickets.map do |ticket|
      { id: ticket.id,
        projectId: ticket.project.unfuddle_id,
        projectSlug: ticket.project.slug,
        projectTitle: ticket.project.name,
        projectColor: ticket.project.color,
        number: ticket.number,
        summary: ticket.summary,
        verdict: ticket.verdict.downcase,
        verdictsByTester: ticket.verdicts_by_tester_index,
        queue: ticket.queue,
        committers: ticket.committers,
        deployment: ticket.deployment,
        age: ticket.age,
        
        testingNotes: TestingNotePresenter.new(ticket.testing_notes).as_json,
        commits: CommitPresenter.new(ticket.commits).as_json,
        releases: ReleasePresenter.new(ticket.releases).as_json,
        lastReleaseAt: ticket.last_release_at,
        unfuddleUrl: unfuddle_ticket_url(ticket),
        description: BlueCloth::new(ticket.description).to_html }
    end
  end
  
end
