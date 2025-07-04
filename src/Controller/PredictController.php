<?php

namespace App\Controller;

use Symfony\Bundle\FrameworkBundle\Controller\AbstractController;
use Symfony\Component\HttpFoundation\Request;
use Symfony\Component\HttpFoundation\Response;
use Symfony\Component\HttpFoundation\JsonResponse;
use Symfony\Component\Routing\Annotation\Route;
use Symfony\Component\HttpFoundation\File\Exception\FileException;
use Symfony\Contracts\HttpClient\HttpClientInterface;

class PredictController extends AbstractController
{
    private $httpClient;

    public function __construct(HttpClientInterface $httpClient)
    {
        $this->httpClient = $httpClient;
    }

    #[Route('/predict', name: 'app_predict', methods: ['GET', 'POST'])]
    public function index(Request $request): Response
    {
        if ($request->isMethod('POST')) {
            $image = $request->files->get('image');

            if ($image) {
                $filePath = $image->getPathname();

                $flaskUrl = $_SERVER['FLASK_API_URL'] ?? 'http://127.0.0.1:7860';

                print_r($flaskUrl);
                

                // Send to Python API
                // 
                // $response = $this->httpClient->request('POST', 'http://host.docker.internal:5000/predict', [

                

                // TAKE OUT ENV VARIABLES AND SEE IF WILL WORK. 
                //ALSO CHANGE ENV BACK TO PORT 5000

                $response = $this->httpClient->request('POST', $flaskUrl . '/predict', [
                // $response = $this->httpClient->request('POST', 'http://127.0.0.1:5050/predict', [
                    'headers' => [
                         'Accept' => 'application/json'
                        ],
                    'body' => [
                        'image' => fopen($filePath, 'r')
                        ]
                ]);


                print_r($response->getContent());

                $result = $response->toArray();

                return $this->render('predict/result.html.twig', [
                    'prediction' => $result['prediction'] ?? 'Unknown',
                    'confidence' => $result['confidence'] ?? null,
                ]);
            }
        }

        return $this->render('predict/index.html.twig');
    }
}
