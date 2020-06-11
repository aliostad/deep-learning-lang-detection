package org.motechproject.mtraining.service.impl;

import org.junit.Test;
import org.motechproject.mtraining.domain.NodeType;

import static junit.framework.Assert.assertEquals;
import static org.mockito.Mockito.mock;

public class NodeHandlerFactoryTest {
    @Test
    public void shouldGiveAppropriateHandlersForAllNodeTypes() {
        CourseNodeHandler courseNodeHandler = mock(CourseNodeHandler.class);
        ModuleNodeHandler moduleNodeHandler = mock(ModuleNodeHandler.class);
        ChapterNodeHandler chapterNodeHandler = mock(ChapterNodeHandler.class);
        MessageNodeHandler messageNodeHandler = mock(MessageNodeHandler.class);
        QuizNodeHandler quizNodeHandler = mock(QuizNodeHandler.class);
        QuestionNodeHandler questionNodeHandler = mock(QuestionNodeHandler.class);
        NodeHandlerFactory nodeHandlerFactory = new NodeHandlerFactory(courseNodeHandler, moduleNodeHandler, chapterNodeHandler, messageNodeHandler, quizNodeHandler, questionNodeHandler);

        assertEquals(courseNodeHandler, nodeHandlerFactory.getHandler(NodeType.COURSE));
        assertEquals(moduleNodeHandler, nodeHandlerFactory.getHandler(NodeType.MODULE));
        assertEquals(chapterNodeHandler, nodeHandlerFactory.getHandler(NodeType.CHAPTER));
        assertEquals(messageNodeHandler, nodeHandlerFactory.getHandler(NodeType.MESSAGE));
    }
}
