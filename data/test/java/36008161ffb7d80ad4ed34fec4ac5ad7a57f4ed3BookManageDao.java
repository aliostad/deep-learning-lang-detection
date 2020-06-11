package cn.jbit.dao;

import java.util.List;
import cn.jbit.entity.BookManage;
public interface BookManageDao {
	/**
	 * 查询一条数据
	 * @param id
	 * @return BookManage
	 */
	public BookManage select(int id);
	/**
	 * 查询所有数据
	 * @return List<BookManage>
	 */
	public List<BookManage> list();
	/**
	 * 添加一条数据
	 * @param item
	 * @return int
	 */
	public int Add(BookManage item);
	/**
	 * 删除一条数据
	 * @param id
	 * @return int
	 */
	public int delete(int id);
	/**
	 * 修改一条数据
	 * @param item
	 * @return int
	 */
	public int update(BookManage item);
}
