module RunHelper
  def sequence_switcher(run)
    left = previous_run(run.repository, run.sequence - 1)
    right = next_run(run.repository, run.sequence + 1)

    "#{left} #{run.sequence} #{right}".html_safe
  end

  private

  def previous_run(repository, sequence)
    run = run_from_sequence(repository, sequence)

    if run.present?
      link_to(octicon('chevron-left'), repository_run_path(repository, run))
    else
      octicon('chevron-left')
    end
  end

  def next_run(repository, sequence)
    run = run_from_sequence(repository, sequence)

    if run.present?
      link_to(octicon('chevron-right'), repository_run_path(repository, run))
    else
      octicon('chevron-right')
    end
  end

  def run_from_sequence(repository, sequence)
    repository.runs.where(sequence: sequence).first
  end
end
