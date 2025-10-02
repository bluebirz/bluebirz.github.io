/**
 * readingProgressBar.js - Script para mostrar una barra de progreso de lectura en la parte superior de la página.
 *
 * Autor: Jaime Paez
 * Fecha: 09/04/2022
 */

document.addEventListener('DOMContentLoaded', function () {
  // Crear el elemento de la barra de progreso
  const progressBarContainer = document.createElement('div');
  progressBarContainer.id = 'readingProgressBarContainer';
  const progressBar = document.createElement('div');
  progressBar.id = 'readingProgressBar';
  progressBarContainer.appendChild(progressBar);
  document.body.insertBefore(progressBarContainer, document.body.firstChild); // Insertar al inicio del body

  // Función para actualizar la barra de progreso
  function updateProgressBar() {
    const windowScroll =
      document.body.scrollTop || document.documentElement.scrollTop;
    const documentHeight =
      document.documentElement.scrollHeight -
      document.documentElement.clientHeight;
    const progressPercent = (windowScroll / documentHeight) * 100;
    progressBar.style.width = progressPercent + '%';
    // console.log(progressPercent);
    // background: radial-gradient(closest-side, black 95%, transparent 93% 100%), conic-gradient(hotpink 50%, pink 0);
    // https://nikitahl.com/circle-progress-bar-css
  }

  // Escuchar el evento de scroll para actualizar la barra
  window.addEventListener('scroll', updateProgressBar);
});
