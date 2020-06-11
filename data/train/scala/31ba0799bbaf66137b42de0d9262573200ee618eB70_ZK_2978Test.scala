package org.zkoss.zktest.test2.B70

import org.zkoss.ztl.Tags
import org.zkoss.zstl.ZTL4ScalaTestCase
import org.junit.Test
import org.openqa.selenium.Dimension

@Tags(tags = "B70-ZK-2978.zul")
class B70_ZK_2978Test extends ZTL4ScalaTestCase {

  @Test
  def testClick() = {
    runZTL(
      () => {
        val window = driver.manage().window();
        window.setSize(new Dimension(window.getSize().getWidth(), 400));

        sleep(500);
        
        val groupboxCaption = jq(".z-caption");
        click(groupboxCaption);

        waitResponse(true);
        
        verifyTrue(hasVScrollbar(jq(".menuGroupboxContainer")));
      })

  }
}