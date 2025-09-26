import { AFS } from 'advanced-filter-system';

const afs = new AFS({
  // Required selectors
  containerSelector: '.filter-container',
  itemSelector: '.filter-item',
  filterButtonSelector: '.btn-filter',
  searchInputSelector: '.filter-search',
  counterSelector: '.filter-counter',

  // Search configuration
  searchKeys: ['title', 'categories'],

  // Filter logic (NEW!)
  filterCategoryMode: 'mixed', // OR within categories, AND between
  filterTypeLogic: {
    category: { mode: 'OR', multi: true }, // Multi-select OR
    brand: 'OR', // Toggle mode
    price: 'AND', // Multi-select AND
  },

  // Pagination
  pagination: {
    enabled: true,
    itemsPerPage: 6,
  },

  // Animations
  animation: {
    type: 'fade',
    duration: 300,
  },
});
// Event listeners
afs.on('filter:applied', (data) => {
  console.log(`Filtered: ${data.visible} of ${data.total} items`);
});
