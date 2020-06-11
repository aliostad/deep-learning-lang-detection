<?php

namespace DjPanel\ShowBundle\Controller;

use Symfony\Bundle\FrameworkBundle\Controller\Controller;

class DashboardController extends Controller
{
    public function viewAction($showId)
    {
        $user = $this->get('security.context')->getToken()->getUser();

        $showRepository = $this->getDoctrine()->getRepository("DjPanelShowBundle:Show");
        $show = $showRepository->find($showId);

        if ($show == null) {
            $this->createNotFoundException("Show not found");
        }

        return $this->render("DjPanelShowBundle::dashboard.html.twig", array(
            "show" => $show
        ));
    }
}
