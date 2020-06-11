export default (host, port, protocol) => {
    const apiUrl = `${protocol}://${host}:${port}/api`;
    return {
        add: `${apiUrl}/add_`,
        associate: `${apiUrl}/associate_`,
        cancel: `${apiUrl}/cancel_`,
        create: `${apiUrl}/create_`,
        expo: `${apiUrl}/export_`,
        get: `${apiUrl}/get_`,
        impo: `${apiUrl}/import_`,
        initiate: `${apiUrl}/initiate_`,
        invoke: `${apiUrl}/invoke_`,
        list: `${apiUrl}/list_`,
        promote: `${apiUrl}/promote_`,
        remove: `${apiUrl}/remove_`,
        retry: `${apiUrl}/retry_`,
        run: `${apiUrl}/run_`,
        update: `${apiUrl}/update_`
    }
}

