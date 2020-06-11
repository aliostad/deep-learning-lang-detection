func killProcess(pid []int, ppid []int, kill int) []int {
	tree := make(map[int][]int)
	n := len(pid)
	for i := 0; i < n; i++ {
		parentProcessId := ppid[i]
		processId := pid[i]
		tree[parentProcessId] = append(tree[parentProcessId], processId)
	}
	var queue []int
	var result []int

	queue = append(queue, kill)
	i := 0
	for len(queue) > 0 && i < len(queue) {
		var processId int 
		processId = queue[i]
		i++
		result = append(result, processId)
		childProcess := tree[processId]
		for i := 0; i < len(childProcess); i++ {
			queue = append(queue, childProcess[i])
		}
	}
	return result
}
