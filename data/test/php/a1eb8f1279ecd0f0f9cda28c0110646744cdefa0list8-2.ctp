	<tr>
		<td><?php echo h($customer['Customer']['customer_cd']); ?>&nbsp;</td>
		<td><?php echo h($customer['Customer']['name']); ?>&nbsp;</td>
		<td><?php echo h($customer['Customer']['kana']); ?>&nbsp</td>
		<td><?php echo h($customer['Company']['company_name']); ?></td>
		<td><?php echo h($customer['Prefecture']['pref_name']); ?>&nbsp;</td>
		<td><?php echo h($customer['Customer']['phone']); ?>&nbsp;</td>
		<td><?php echo h($customer['Customer']['email']); ?>&nbsp;</td>

		<td>
			<?php
				/** 更新ボタン */
				echo $this->Html->link(
					__('更新'),
					array('action' => 'edit', $customer['Customer']['id']),
					array('class' => 'btn btn-primary btn-small')
				);
			?>
			<?php
				/** 削除ボタン */
				echo $this->Form->postLink(
					__('削除'),
					array('action' => 'delete', $customer['Customer']['id']),
					array('class' => 'btn btn-primary btn-small'),
					__('削除してもよろしいですか？ # %s?', $customer['Customer']['id'])
				);
			?>
		</td>
	</tr>
