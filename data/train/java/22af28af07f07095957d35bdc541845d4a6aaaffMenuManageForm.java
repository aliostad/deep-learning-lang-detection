package ServerSystem;

import javax.swing.*;

import java.awt.*;
import java.awt.event.ActionEvent;
import java.awt.event.ActionListener;

public class MenuManageForm extends JPanel{
	
	private ServerControlForm F;
	
	JPanel MenuManageFormPanel;
	JPanel MenuManageStringPanel;	
	JPanel MenuManageMenuPanel;	
	JPanel MenuManageButtonPanel ;
	JPanel MenuManageMenuEachPanel;
	
	JLabel MenuManageString;
	
	JButton MenuManageAddButton;
	JButton MenuManageCloseButton;
	JButton MenuManageEditButton;
	JButton MenuManageDeleteButton;
	
	JTextField MenuManageMenuName;
	JTextField MenuManageMenuPrice;
	
	JScrollPane MenuManageMenuScroll;
	
	
	public MenuManageForm(ServerControlForm f){
		
		F = f;
		
		setSize(800, 600);
		
		MenuManageFormPanel = new JPanel();		//전체 판넬
		MenuManageStringPanel = new JPanel();	//맨위 스트링 패턴
		MenuManageMenuPanel = new JPanel();	//중간 메뉴들 나오는 판넬
		MenuManageButtonPanel = new JPanel(); // 메뉴추가/닫기 하는 패널
		MenuManageMenuEachPanel = new JPanel();	//메뉴 하나하나가 있는 판넬
		
		MenuManageFormPanel.setLayout(new BoxLayout(MenuManageFormPanel, BoxLayout.Y_AXIS));
		MenuManageMenuPanel.setLayout(new BoxLayout(MenuManageMenuPanel, BoxLayout.Y_AXIS));
	
		
		MenuManageString = new JLabel("Menu ManageMent");
		MenuManageStringPanel.add(MenuManageString);		//여기까지가 첫번째 맨 위에 스트링 나오는 패널
		
		MenuManageMenuScroll = new JScrollPane(MenuManageMenuEachPanel, JScrollPane.VERTICAL_SCROLLBAR_ALWAYS, JScrollPane.HORIZONTAL_SCROLLBAR_NEVER);
		MenuManageMenuEachPanel.setPreferredSize(new Dimension(600, 5000));
		MenuManageMenuScroll.setPreferredSize(new Dimension(600, 400));
		
		int size = 50;
		for(int i = 0 ; i <size;i++){
			MenuManageMenuName = new JTextField(30);
			MenuManageMenuName.setText(""+i); //메뉴 이름 가져오고
			MenuManageMenuName.setEditable(false);
			
			MenuManageMenuPrice = new JTextField(10);
			MenuManageMenuPrice.setText(""); //메뉴 가격 가져오고
			MenuManageMenuPrice.setEditable(false);
			
			MenuManageEditButton = new JButton("수정");
			MenuManageDeleteButton = new JButton("삭제");
			
			MenuManageMenuEachPanel.add(MenuManageMenuName);
			MenuManageMenuEachPanel.add(MenuManageMenuPrice);
			MenuManageMenuEachPanel.add(MenuManageEditButton);
			MenuManageMenuEachPanel.add(MenuManageDeleteButton);

		}
		
		MenuManageMenuPanel.add(MenuManageMenuScroll);
		
		MenuManageAddButton = new JButton("메뉴 추가");
		MenuManageCloseButton = new JButton("이전");
		MenuManageCloseButton.addActionListener(new ActionListener(){		//이전 ACTION
            public void actionPerformed(ActionEvent e) {
            		F.changePanel("ManageStartForm");
            }
        });
		MenuManageButtonPanel.add(MenuManageAddButton);
		MenuManageButtonPanel.add(MenuManageCloseButton);
		
		
		MenuManageFormPanel.add(MenuManageStringPanel);
		MenuManageFormPanel.add(MenuManageMenuPanel);
		MenuManageFormPanel.add(MenuManageButtonPanel);
		
		add(MenuManageFormPanel);
		setVisible(true);
	}
}
