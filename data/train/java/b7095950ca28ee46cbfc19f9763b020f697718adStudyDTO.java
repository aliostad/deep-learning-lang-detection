package ca.polymtl.seodin.service.dto;

import ca.polymtl.seodin.domain.*;
import ca.polymtl.seodin.repository.*;

import javax.validation.constraints.NotNull;
import java.util.HashSet;
import java.util.List;
import java.util.Set;

/**
 * A DTO representing a Study, with all its details.
 */
public class StudyDTO {

    private Long id;

    @NotNull
    private String title;

    private String description;

    private String author;

    DeveloperRepository developerRepository;
    List<Developer> developers;
    DeveloperDTO developerDTO;
    Set<DeveloperDTO> developerDTOS = new HashSet<DeveloperDTO>();

    SoftwareSystemRepository softwareSystemRepository;
    List<SoftwareSystem> softwareSystems;
    SoftwareSystemDTO softwareSystemDTO;
    Set<SoftwareSystemDTO> softwareSystemDTOS = new HashSet<SoftwareSystemDTO>();

    TaskRepository taskRepository;
    List<Task> tasks;
    TaskDTO taskDTO;
    Set<TaskDTO> taskDTOS = new HashSet<TaskDTO>();

    ScriptRepository scriptRepository;
    List<Script> scripts;
    ScriptDTO scriptDTO;
    Set<ScriptDTO> scriptDTOS = new HashSet<ScriptDTO>();

    InterviewRepository interviewRepository;
    ThinkAloudRepository thinkAloudRepository;
    DiaryRepository diaryRepository;
    DefectRepository defectRepository;
    TestCaseRepository testCaseRepository;
    InteractiveLogRepository interactiveLogRepository;
    SourceCodeRepository sourceCodeRepository;
    DesignPatternRepository designPatternRepository;
    NoteRepository noteRepository;
    AudioRepository audioRepository;
    VideoRepository videoRepository;

    public StudyDTO() {
        // Empty constructor needed for Jackson.
    }

    public StudyDTO(Study study, DeveloperRepository developerRepository, SoftwareSystemRepository softwareSystemRepository, InterviewRepository interviewRepository, ThinkAloudRepository thinkAloudRepository, DiaryRepository diaryRepository, DefectRepository defectRepository, TestCaseRepository testCaseRepository, InteractiveLogRepository interactiveLogRepository, SourceCodeRepository sourceCodeRepository, DesignPatternRepository designPatternRepository, TaskRepository taskRepository, NoteRepository noteRepository, ScriptRepository scriptRepository, AudioRepository audioRepository, VideoRepository videoRepository) {
        this.id= study.getId();
        this.title = study.getTitle();
        this.author = study.getAuthor();
        this.description = study.getDescription();
        this.developerRepository = developerRepository;
        this.softwareSystemRepository = softwareSystemRepository;
        this.interviewRepository = interviewRepository;
        this.thinkAloudRepository = thinkAloudRepository;
        this.diaryRepository = diaryRepository;
        this.defectRepository = defectRepository;
        this.testCaseRepository = testCaseRepository;
        this.interactiveLogRepository = interactiveLogRepository;
        this.sourceCodeRepository = sourceCodeRepository;
        this.designPatternRepository = designPatternRepository;
        this.taskRepository = taskRepository;
        this.noteRepository = noteRepository;
        this.scriptRepository = scriptRepository;
        this.audioRepository = audioRepository;
        this.videoRepository = videoRepository;
    }

    public Long getId() {
        return id;
    }

    public String getAuthor() {
        return author;
    }

    public String getTitle() {
        return title;
    }

    public String getDescription() {
        return description;
    }

    public Set<DeveloperDTO> getDevelopers() {
        developers = developerRepository.findAllByStudyTitle(title);
        for (Developer developer:developers){
            developerDTO = new DeveloperDTO(developer, interviewRepository, thinkAloudRepository, diaryRepository, defectRepository, testCaseRepository, interactiveLogRepository, audioRepository, videoRepository, noteRepository);
            developerDTOS.add(developerDTO);
        }
        return developerDTOS;
    }

    public Set<SoftwareSystemDTO> getSoftwareSystems() {
        softwareSystems = softwareSystemRepository.findAllByStudyTitle(title);
        for (SoftwareSystem softwareSystem:softwareSystems){
            softwareSystemDTO = new SoftwareSystemDTO(softwareSystem, sourceCodeRepository, designPatternRepository);
            softwareSystemDTOS.add(softwareSystemDTO);
        }
        return softwareSystemDTOS;
    }

    public Set<TaskDTO> getTasks() {
        tasks = taskRepository.findAllByStudyTitle(title);
        for (Task task:tasks){
            taskDTO = new TaskDTO(task);
            taskDTOS.add(taskDTO);
        }
        return taskDTOS;
    }

    public Set<ScriptDTO> getScripts() {
        scripts = scriptRepository.findAllByStudyTitle(title);
        for (Script script:scripts){
            scriptDTO = new ScriptDTO(script);
            scriptDTOS.add(scriptDTO);
        }
        return scriptDTOS;
    }
}
