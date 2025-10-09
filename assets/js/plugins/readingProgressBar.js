/**
 * readingProgressBar.js - Script para mostrar una barra de progreso de lectura en la parte superior de la página.
 *
 * Autor: Jaime Paez
 * Fecha: 09/04/2022
 */

document.addEventListener('DOMContentLoaded', function () {
  const progressBar = document.getElementById('back-to-top');

  function updateProgressBar() {
    const windowScroll =
      document.body.scrollTop || document.documentElement.scrollTop;
    const documentHeight =
      document.documentElement.scrollHeight -
      document.documentElement.clientHeight;
    const progressPercent = (windowScroll / documentHeight) * 100;
    progressBar.style.background = `radial-gradient(closest-side, var(--main-bg) 85%, transparent 90%), conic-gradient(var(--btn-backtotop-color) ${progressPercent}%, var(--main-bg) 0)`;
  }

  window.addEventListener('scroll', updateProgressBar);
});
